# Ensure that STOW_FOLDERS is defined
if (-not $STOW_FOLDERS) {
    $STOW_FOLDERS = "bin,yabai,tmux,alacritty,spacebar,skhd,zsh,powerlevel10k,zellij,nvim,starship,kitty"
}

# Ensure that DOTFILES is defined
if (-not $DOTFILES) {
    $DOTFILES = "$env:USERPROFILE\.dotfiles"
}

# Change to the DOTFILES directory
Set-Location -Path $DOTFILES

# Loop through the folders and "stow" them (assuming stow is available on Windows, or you have an equivalent solution)
$STOW_FOLDERS -split "," | ForEach-Object {
    $folder = $_
    Write-Host "stow $folder"
    
    # Use your stow equivalent command or script for Windows here
    # Assuming a similar function is available for symlink management on Windows
    # Example: New-Item -ItemType SymbolicLink -Path "$env:USERPROFILE\$folder" -Target "$DOTFILES\$folder"
    
    # For now, we simply simulate stowing by displaying the action
    Write-Host "Simulating stow for $folder"
}

# Change back to the previous directory
Pop-Location

