use clap::Parser;
use std::collections::HashMap;
use std::collections::hash_map::DefaultHasher;
use std::env;
use std::hash::{Hash, Hasher};
use std::path::{Path, PathBuf};
use std::process::Command;
use walkdir::WalkDir;

#[derive(Parser, Debug)]
#[command(author, version, about, long_about = None)]
struct Args {
    /// Paths to search (relative to home directory unless starting with /)
    #[arg(required = true, num_args = 1..)]
    paths: Vec<String>,

    /// Maximum depth to search
    #[arg(short, long, default_value_t = 1)]
    depth: usize,

    /// Also print the computed session id: "(<type>)\t<id>\t<path>"
    ///
    /// The id collects the hierarchy (see docs/session-model.md §5): a worktree
    /// is "<repo>@<ref>", a submodule is its path relative to the search root,
    /// everything else is its path relative to the search root.
    #[arg(long)]
    ids: bool,
}

fn expand_path(path: &str, home: &Path) -> PathBuf {
    if path.starts_with('/') {
        PathBuf::from(path)
    } else if let Some(rest) = path.strip_prefix("~/") {
        home.join(rest)
    } else if path == "~" {
        home.to_path_buf()
    } else {
        home.join(path)
    }
}

/// Run `git -C <dir> <args>` and return trimmed stdout on success.
fn run_git(dir: &Path, args: &[&str]) -> Option<String> {
    let output = Command::new("git")
        .arg("-C")
        .arg(dir)
        .args(args)
        .output()
        .ok()?;
    if !output.status.success() {
        return None;
    }
    Some(
        String::from_utf8_lossy(&output.stdout)
            .trim()
            .to_string(),
    )
}

#[derive(Clone, PartialEq, Debug)]
enum DirType {
    BareGit,
    WorkTree,
    Submodule,
    Git,
    Dir,
}

impl DirType {
    fn tag(&self) -> &'static str {
        match self {
            DirType::BareGit => "bare",
            DirType::WorkTree => "wt",
            DirType::Submodule => "sub",
            DirType::Git => "git",
            DirType::Dir => "dir",
        }
    }

    /// Higher = more specific; used to break ties when the same path is found
    /// by more than one search strategy.
    fn rank(&self) -> u8 {
        match self {
            DirType::WorkTree | DirType::Submodule => 3,
            DirType::BareGit => 2,
            DirType::Git => 1,
            DirType::Dir => 0,
        }
    }
}

#[derive(Clone, Debug)]
struct Candidate {
    dir_type: DirType,
    path: PathBuf,
    /// The search root this candidate was found under (for relative ids).
    root: PathBuf,
    /// Precomputed id for worktrees (`<repo>@<ref>`); `None` otherwise.
    explicit_id: Option<String>,
}

/// Classify a single directory.
///
/// The `.git` / `HEAD` presence guard is what stops us from mistaking a plain
/// subdirectory *inside* a repo for a repo of its own; it also means we only
/// pay for a `git` spawn when a directory actually looks like one.
fn classify(dir: &Path) -> DirType {
    if !dir.join(".git").exists() && !dir.join("HEAD").is_file() {
        return DirType::Dir;
    }

    // A single `rev-parse` answers everything, in argument order.
    let Some(out) = run_git(
        dir,
        &[
            "rev-parse",
            "--is-inside-git-dir",
            "--is-inside-work-tree",
            "--absolute-git-dir",
            "--git-common-dir",
            "--show-superproject-working-tree",
        ],
    ) else {
        return DirType::Dir;
    };

    let lines: Vec<&str> = out.lines().collect();
    let inside_git_dir = lines.first().copied().unwrap_or("");
    let inside_work_tree = lines.get(1).copied().unwrap_or("");
    let git_dir = lines.get(2).copied().unwrap_or("");
    let common = lines.get(3).copied().unwrap_or("");
    let superproject = lines.get(4).copied().unwrap_or("");

    // Bare repo: git storage, not the `.git` dir itself.
    if inside_git_dir == "true" && dir.file_name().map_or(false, |name| name != ".git") {
        return DirType::BareGit;
    }

    if inside_work_tree == "true" {
        // Submodule: has a superproject working tree above it.
        if !superproject.is_empty() {
            return DirType::Submodule;
        }
        // Worktree: its git dir is separate from the common git dir.
        let common_path = PathBuf::from(common);
        let common_abs = if common_path.is_absolute() {
            common_path
        } else {
            dir.join(common_path)
        };
        if Path::new(git_dir) != common_abs.as_path() {
            return DirType::WorkTree;
        }
        return DirType::Git;
    }

    DirType::Dir
}

/// Live, non-bare worktrees attached to `repo` (excluding `main`, the repo's
/// own working tree). Prunable / missing worktrees are skipped.
fn list_worktrees(repo: &Path, main: &Path) -> Vec<PathBuf> {
    let Some(text) = run_git(repo, &["worktree", "list", "--porcelain"]) else {
        return Vec::new();
    };
    let main = main.to_string_lossy();

    let mut worktrees = Vec::new();
    for block in text.split("\n\n") {
        let mut path = None;
        let mut bare = false;
        let mut prunable = false;

        for line in block.lines() {
            if let Some(p) = line.strip_prefix("worktree ") {
                path = Some(PathBuf::from(p));
            } else if line == "bare" {
                bare = true;
            } else if line.starts_with("prunable") {
                prunable = true;
            }
        }

        let Some(path) = path else { continue };
        if bare || prunable {
            continue;
        }
        if path.to_string_lossy() == main {
            continue;
        }
        if !path.exists() {
            continue;
        }
        worktrees.push(path);
    }
    worktrees
}

/// Repo name from a `.git` / common dir: `.../x/.git` -> `x`,
/// `.../x.git` -> `x`.
fn repo_name_from_common(common: &Path) -> String {
    let base = common
        .file_name()
        .map(|s| s.to_string_lossy().to_string())
        .unwrap_or_default();
    if base == ".git" {
        common
            .parent()
            .and_then(|p| p.file_name())
            .map(|s| s.to_string_lossy().to_string())
            .unwrap_or(base)
    } else {
        base.strip_suffix(".git").unwrap_or(&base).to_string()
    }
}

/// The `<repo>@<ref>` id for a worktree.
fn worktree_id(path: &Path) -> Option<String> {
    let common = run_git(path, &["rev-parse", "--git-common-dir"])?;
    let common_path = PathBuf::from(&common);
    let common_abs = if common_path.is_absolute() {
        common_path
    } else {
        path.join(common_path)
    };
    let repo = repo_name_from_common(&common_abs);

    let mut reference =
        run_git(path, &["rev-parse", "--abbrev-ref", "HEAD"]).unwrap_or_default();
    if reference.is_empty() || reference == "HEAD" {
        reference =
            run_git(path, &["rev-parse", "--short", "HEAD"]).unwrap_or_else(|| "detached".into());
    }

    Some(format!("{}@{}", slug(&repo), slug(&reference)))
}

/// Lowercase, collapse anything outside `[a-z0-9@/-]` to `-`, trim dashes.
/// Keeps `/` and `@` so hierarchy and worktree markers survive.
fn slug(input: &str) -> String {
    let mut out = String::new();
    let mut last_dash = false;
    for ch in input.chars() {
        let c = ch.to_ascii_lowercase();
        let keep = c.is_ascii_alphanumeric() || c == '/' || c == '@' || c == '-';
        if keep {
            out.push(c);
            last_dash = c == '-';
        } else if !last_dash {
            out.push('-');
            last_dash = true;
        }
    }
    out.trim_matches('-').to_string()
}

/// Path relative to the search root, slugged segment by segment.
fn rel_slug(path: &Path, root: &Path) -> Option<String> {
    let rel = path.strip_prefix(root).ok()?;
    let mut parts = Vec::new();
    for component in rel.components() {
        let part = slug(&component.as_os_str().to_string_lossy());
        if !part.is_empty() {
            parts.push(part);
        }
    }
    if parts.is_empty() {
        None
    } else {
        Some(parts.join("/"))
    }
}

fn base_id(candidate: &Candidate) -> String {
    if let Some(id) = &candidate.explicit_id {
        return id.clone();
    }
    match candidate.dir_type {
        DirType::BareGit => {
            let name = candidate
                .path
                .file_name()
                .map(|s| s.to_string_lossy().to_string())
                .unwrap_or_default();
            slug(&name)
        }
        _ => rel_slug(&candidate.path, &candidate.root).unwrap_or_else(|| {
            slug(
                candidate
                    .path
                    .file_name()
                    .map(|s| s.to_string_lossy().to_string())
                    .unwrap_or_default()
                    .as_str(),
            )
        }),
    }
}

fn short_hash(path: &Path) -> String {
    let mut hasher = DefaultHasher::new();
    path.hash(&mut hasher);
    format!("{:08x}", hasher.finish())[..4].to_string()
}

/// Soft cap from docs/session-model.md §5.2.
const MAX_ID_LEN: usize = 64;

fn cap_id(id: String, path: &Path) -> String {
    if id.chars().count() <= MAX_ID_LEN {
        return id;
    }
    let hash = short_hash(path);
    let budget = MAX_ID_LEN.saturating_sub(hash.len() + 1); // room for "~<hash>"

    // Prefer dropping whole middle path segments, keeping the first and last.
    let segments: Vec<&str> = id.split('/').collect();
    if segments.len() > 1 {
        let mut keep: Vec<&str> = segments.clone();
        while keep.len() > 1 {
            let candidate = keep.join("/");
            if candidate.chars().count() <= budget {
                return format!("{candidate}~{hash}");
            }
            keep.remove(1);
        }
    }

    // Fall back to keeping the head and tail of the string.
    let chars: Vec<char> = id.chars().collect();
    let head_len = budget / 2;
    let tail_len = budget - head_len;
    let head: String = chars.iter().take(head_len).collect();
    let tail: String = chars.iter().skip(chars.len() - tail_len).collect();
    let head = head.trim_end_matches(['/', '@', '-']);
    let tail = tail.trim_start_matches(['/', '@', '-']);
    format!("{head}~{tail}~{hash}")
}

/// Walk a base directory, classifying every directory found.
fn process_entries(
    base: &Path,
    root: &Path,
    depth: usize,
    level: Option<usize>,
) -> Vec<Candidate> {
    let level = level.unwrap_or(0);
    let mut results = Vec::new();

    for entry in WalkDir::new(base)
        .min_depth(1)
        .max_depth(depth)
        .into_iter()
        .filter_entry(|e| e.file_type().is_dir() && e.file_name() != ".git")
    {
        let Ok(entry) = entry else { continue };
        let path = entry.path();
        if !path.exists() {
            continue;
        }

        let dir_type = classify(path);
        let explicit_id = if dir_type == DirType::WorkTree {
            worktree_id(path)
        } else {
            None
        };

        results.push(Candidate {
            dir_type: dir_type.clone(),
            path: path.to_path_buf(),
            root: root.to_path_buf(),
            explicit_id,
        });

        match dir_type {
            DirType::Git | DirType::Submodule => {
                for worktree in list_worktrees(path, path) {
                    results.push(Candidate {
                        dir_type: DirType::WorkTree,
                        explicit_id: worktree_id(&worktree),
                        path: worktree,
                        root: root.to_path_buf(),
                    });
                }
                // Nested repos (submodules) live inside the working tree.
                let mut nested = process_entries(path, root, 3, Some(99));
                nested.retain(|c| matches!(c.dir_type, DirType::Git | DirType::Submodule));
                results.append(&mut nested);
            }
            DirType::BareGit => {
                for worktree in list_worktrees(path, path) {
                    results.push(Candidate {
                        dir_type: DirType::WorkTree,
                        explicit_id: worktree_id(&worktree),
                        path: worktree,
                        root: root.to_path_buf(),
                    });
                }
            }
            DirType::Dir => {
                if level <= 1 {
                    let mut nested = process_entries(path, root, 1, Some(level + 1));
                    nested.retain(|c| c.dir_type != DirType::Dir);
                    results.append(&mut nested);
                }
            }
            DirType::WorkTree => {}
        }
    }

    results
}

/// Dedupe by path, assign ids, and disambiguate collisions.
fn build_rows(candidates: Vec<Candidate>) -> Vec<(String, String, String)> {
    // 1. Dedupe, keeping the most specific candidate per path.
    let mut index: HashMap<PathBuf, usize> = HashMap::new();
    let mut kept: Vec<Candidate> = Vec::new();
    for candidate in candidates {
        match index.get(&candidate.path) {
            Some(&i) => {
                let better = candidate.dir_type.rank() > kept[i].dir_type.rank()
                    || (candidate.explicit_id.is_some() && kept[i].explicit_id.is_none());
                if better {
                    kept[i] = candidate;
                }
            }
            None => {
                index.insert(candidate.path.clone(), kept.len());
                kept.push(candidate);
            }
        }
    }

    // 2. Base ids.
    let mut ids: Vec<String> = kept.iter().map(base_id).collect();

    // 3. Collisions: first try a root prefix, then a short path hash.
    let mut counts: HashMap<&String, usize> = HashMap::new();
    for id in &ids {
        *counts.entry(id).or_insert(0) += 1;
    }
    let duplicates: Vec<bool> = ids.iter().map(|id| counts[id] > 1).collect();
    drop(counts);
    for ((candidate, id), duplicated) in kept.iter().zip(ids.iter_mut()).zip(duplicates) {
        if duplicated {
            let root = candidate
                .root
                .file_name()
                .map(|s| slug(&s.to_string_lossy()))
                .unwrap_or_default();
            if !root.is_empty() && !id.starts_with(&format!("{root}/")) {
                *id = format!("{root}/{id}");
            }
        }
    }

    let mut counts: HashMap<&String, usize> = HashMap::new();
    for id in &ids {
        *counts.entry(id).or_insert(0) += 1;
    }
    let duplicates: Vec<bool> = ids.iter().map(|id| counts[id] > 1).collect();
    drop(counts);
    for ((candidate, id), duplicated) in kept.iter().zip(ids.iter_mut()).zip(duplicates) {
        if duplicated {
            *id = format!("{}~{}", id, short_hash(&candidate.path));
        }
    }

    // 4. Cap length and sort for stable output.
    let mut rows: Vec<(String, String, String)> = kept
        .iter()
        .zip(ids)
        .map(|(candidate, id)| {
            (
                candidate.dir_type.tag().to_string(),
                cap_id(id, &candidate.path),
                candidate.path.display().to_string(),
            )
        })
        .collect();
    rows.sort_by(|a, b| a.1.cmp(&b.1).then_with(|| a.2.cmp(&b.2)));
    rows
}

fn main() {
    let args = Args::parse();
    let home = PathBuf::from(env::var("HOME").expect("Failed to get HOME directory"));

    let mut candidates = Vec::new();
    for path in &args.paths {
        let full_path = expand_path(path, &home);
        if !full_path.exists() {
            continue;
        }
        // Canonicalize so walk paths match the absolute paths `git` reports
        // (macOS symlinks like /var -> /private/var otherwise defeat every
        // == comparison: classification, dedupe, and worktree matching).
        let full_path = full_path.canonicalize().unwrap_or(full_path);
        candidates.extend(process_entries(&full_path, &full_path, args.depth, None));
    }

    for (tag, id, path) in build_rows(candidates) {
        if args.ids {
            println!("({tag})\t{id}\t{path}");
        } else {
            println!("({tag})\t{path}");
        }
    }
}
