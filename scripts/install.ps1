param(
    [string]$Skill,
    [string]$Destination = "$env:USERPROFILE\.codex\skills"
)

$ErrorActionPreference = "Stop"

$repoRoot = Split-Path -Parent $PSScriptRoot
$skillsRoot = Join-Path $repoRoot "skills"

if (-not (Test-Path $skillsRoot)) {
    throw "Missing skills directory: $skillsRoot"
}

New-Item -ItemType Directory -Force -Path $Destination | Out-Null

$skills = if ($Skill) {
    @(Get-Item -LiteralPath (Join-Path $skillsRoot $Skill))
} else {
    @(Get-ChildItem -LiteralPath $skillsRoot -Directory)
}

foreach ($item in $skills) {
    $source = $item.FullName
    $target = Join-Path $Destination $item.Name

    if (-not (Test-Path (Join-Path $source "SKILL.md"))) {
        throw "Skill is missing SKILL.md: $source"
    }

    if (Test-Path $target) {
        Remove-Item -LiteralPath $target -Recurse -Force
    }

    robocopy $source $target /E /XF *.meta | Out-Null
    if ($LASTEXITCODE -ge 8) {
        throw "Failed to install $($item.Name). robocopy exit code: $LASTEXITCODE"
    }

    Write-Host "Installed $($item.Name) -> $target"
}
