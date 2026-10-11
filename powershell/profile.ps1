# Ensure locally built/installed binaries are on PATH.
# Mirrors zsh/paths.sh on macOS. `rust/install.ps1` installs into this directory.
$localBin = Join-Path $HOME ".local\bin"
if ($env:Path -notlike "*$localBin*") {
    $env:Path = "$localBin;$env:Path"
}
