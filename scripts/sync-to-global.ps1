param(
    [string]$Category,
    [string]$Skill,
    [string]$Destination = "$env:USERPROFILE\.codex\skills"
)

$ErrorActionPreference = "Stop"

$installScript = Join-Path $PSScriptRoot "install.ps1"

& $installScript @PSBoundParameters

if (-not $?) {
    exit 1
}

exit 0
