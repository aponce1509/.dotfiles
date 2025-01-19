# Check if STOW_FOLDERS is defined, otherwise set a default value
if (-not $STOW_FOLDERS) {
    $STOW_FOLDERS = "bin,yabai,tmux,alacritty,spacebar,skhd,zsh,powerlevel10k,zellij,nvim,starship,kitty"
}

# Check if DOTFILES is defined, otherwise set a default value
if (-not $DOTFILES) {
    $DOTFILES = "$env:USERPROFILE\.dotfiles"
}

# Navigate to the DOTFILES directory
Set-Location -Path $DOTFILES

# Remove and re-apply symlinks for Visual Studio Code (adjust paths as necessary)
Remove-Item "$env:APPDATA\Code\User\vscode-mac" -Force -Recurse
New-Item -Path "$env:APPDATA\Code\User" -Name "vscode-mac" -ItemType Directory

# Go back to the previous directory
Pop-Location

# Execute the install script
$env:STOW_FOLDERS = $STOW_FOLDERS
$env:DOTFILES = $DOTFILES
& "$DOTFILES\install.ps1"

