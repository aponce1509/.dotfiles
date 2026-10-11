# Build and install every Rust utility in this workspace.
#
# Windows counterpart of `install`.
#
# Binaries land in "$env:USERPROFILE\.local\bin". Make sure that directory is on
# PATH (see ../powershell/profile.ps1) so the sessioner scripts can find them.
$ErrorActionPreference = "Stop"

$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$DestRoot = if ($env:RUST_INSTALL_ROOT) { $env:RUST_INSTALL_ROOT } else { Join-Path $env:USERPROFILE ".local" }
$DestBin = Join-Path $DestRoot "bin"

if (-not (Get-Command cargo -ErrorAction SilentlyContinue)) {
    Write-Error "cargo not found. Install Rust first: https://rustup.rs"
    exit 1
}

New-Item -ItemType Directory -Force -Path $DestBin | Out-Null

$installed = 0
Get-ChildItem -Path $ScriptDir -Directory | ForEach-Object {
    $manifest = Join-Path $_.FullName "Cargo.toml"
    if (-not (Test-Path $manifest)) { return }

    $hasMain = Test-Path (Join-Path $_.FullName "src\main.rs")
    $hasBin = $hasMain -or (Select-String -Path $manifest -Pattern '^\[\[bin\]\]' -Quiet)
    if (-not $hasBin) {
        Write-Host "skip  $($_.Name) (no binary target)"
        return
    }

    Write-Host "build $($_.Name)"
    cargo install --path $_.FullName --root $DestRoot --locked --force
    if ($LASTEXITCODE -ne 0) { throw "cargo install failed for $($_.Name)" }
    $installed++
}

if ($installed -eq 0) { throw "No binary crates found under $ScriptDir" }

Write-Host "Installed $installed crate(s) into $DestBin"
