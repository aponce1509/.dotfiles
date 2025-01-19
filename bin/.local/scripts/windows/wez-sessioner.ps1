# TODO: Relative paths do not work
#
# Check if WezTerm is installed
if (-not (Get-Command 'wezterm' -ErrorAction SilentlyContinue)) {
    Write-Host "WezTerm is not installed. Please install it first."
    exit 1
}

# Check if we are in a WezTerm terminal
if (-not $env:WEZTERM_CONFIG_DIR) {
    Write-Host "You have to execute this in a WezTerm terminal."
    exit 1
}

# Check if fzf is installed
if (-not (Get-Command 'fzf' -ErrorAction SilentlyContinue)) {
    Write-Host "fzf is not installed. Please install it first."
    exit 1
}

# Determine the selected workspace
if ($args.Count -eq 1 -and $args[0] -ne '--kill') {
    $selected = $args[0]
} else {
    $selected = directory_finder ~/repos ~/OneDrive/Documents --depth 1 |
    fzf | 
    ForEach-Object { $_ -replace '^[^)]*\)\s*', '' }
}

# Exit if no selection is made
if (-not $selected) {
    exit 0
}

# Extract the workspace_cwd (removing non-alphanumeric characters at the start)
#$workspace_cwd = $selected -replace '^[^a-zA-Z/]*', ''
$workspace_cwd = $selected -replace '^[^\w/\.]*', ''

function Switch-Workspace {
    param (
        [Parameter(Position = 0, Mandatory = $true)]
        [string]$WorkspaceName,

        [Parameter(Position = 1, Mandatory = $false)]
        [string]$WorkspaceCwd
    )

    # Create the JSON payload
    $jsonPayload = @"
{
    "cmd": "switch-workspace",
    "cwd": "$WorkspaceCwd",
    "name": "$WorkspaceName"
}
"@

    # Encode the JSON payload in Base64
    $base64Payload = [Convert]::ToBase64String([System.Text.Encoding]::UTF8.GetBytes($jsonPayload))

    # Print the ANSI escape sequence
    $ansiSequence = "`e]1337;SetUserVar=hacky-user-command=$base64Payload`a"
    Write-Host -NoNewline $ansiSequence
}

# Convert selected directory name into a valid workspace name
$selected_name = (Split-Path -Leaf $selected) -replace '\.', '_'

# Switch to the selected workspace
Switch-Workspace -WorkspaceName $selected_name -WorkspaceCwd $workspace_cwd

# Optionally kill the current pane
#if ($args -contains '--kill') {
#wezterm cli kill-pane
#}

exit 0

