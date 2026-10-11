# Session picker for WezTerm (Windows).
#
# Naming model: docs/session-model.md §5. Mirrors
# bin/.local/scripts/wez-sessioner: `directory_finder --ids` yields
# "(<type>)<TAB><id><TAB><path>" and the id becomes the workspace name.

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

# Check if directory_finder is installed
if (-not (Get-Command 'directory_finder' -ErrorAction SilentlyContinue)) {
    Write-Host "directory_finder is not installed. Please install it first."
    exit 1
}

# Mirror directory_finder's slug rules for a single path segment: lowercase,
# anything outside [a-z0-9@/-] becomes '-', collapse runs, trim dashes.
function Get-Slug([string]$value) {
    $slug = $value.ToLower() -replace '[^a-z0-9@/\-]', '-'
    $slug = $slug -replace '-+', '-'
    return $slug.Trim('-')
}

# Determine the selected workspace id and working directory
if ($args.Count -ge 1 -and $args[0] -ne '--kill') {
    $selectedCwd = $args[0]
    $selectedId = Get-Slug (Split-Path -Leaf $args[0])
} else {
    $line = directory_finder ~/repos ~/ai-repos ~/OneDrive/Documents --depth 1 --ids |
        fzf --delimiter "`t" --with-nth 2,3 --nth 2,3
    if (-not $line) {
        exit 0
    }
    $parts = $line -split "`t"
    $selectedId = $parts[1]
    $selectedCwd = $parts[2]
}

# Exit if no selection is made
if (-not $selectedId -or -not $selectedCwd) {
    exit 0
}

function Switch-Workspace {
    param (
        [Parameter(Position = 0, Mandatory = $true)]
        [string]$WorkspaceName,

        [Parameter(Position = 1, Mandatory = $true)]
        [string]$WorkspaceCwd
    )

    # Build the payload with ConvertTo-Json so paths are escaped correctly.
    $jsonPayload = @{
        cmd  = 'switch-workspace'
        cwd  = $WorkspaceCwd
        name = $WorkspaceName
    } | ConvertTo-Json -Compress

    # Encode the JSON payload in Base64
    $base64Payload = [Convert]::ToBase64String([System.Text.Encoding]::UTF8.GetBytes($jsonPayload))

    # Print the ANSI escape sequence
    $ansiSequence = "`e]1337;SetUserVar=hacky-user-command=$base64Payload`a"
    Write-Host -NoNewline $ansiSequence
}

# Switch to the selected workspace
Switch-Workspace -WorkspaceName $selectedId -WorkspaceCwd $selectedCwd

# Optionally kill the current pane
#if ($args -contains '--kill') {
#    wezterm cli kill-pane
#}

exit 0
