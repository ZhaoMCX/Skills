param(
    [string]$Skill,
    [string]$Destination = "$env:USERPROFILE\.codex\skills"
)

$ErrorActionPreference = "Stop"

$repoRoot = Split-Path -Parent $PSScriptRoot
$skillsRoot = Join-Path $repoRoot "skills"

if (-not (Test-Path -LiteralPath $skillsRoot)) {
    throw "Missing skills directory: $skillsRoot"
}

function Get-SkillDirectories {
    Get-ChildItem -LiteralPath $skillsRoot -Directory | Where-Object {
        Test-Path -LiteralPath (Join-Path $_.FullName "SKILL.md")
    }
}

New-Item -ItemType Directory -Force -Path $Destination | Out-Null

$skills = @(Get-SkillDirectories)

if ($Skill) {
    $skills = @($skills | Where-Object { $_.Name -eq $Skill })
    if ($skills.Count -eq 0) {
        throw "Unknown skill '$Skill'."
    }
}

foreach ($item in $skills) {
    $source = $item.FullName
    $target = Join-Path $Destination $item.Name

    if (Test-Path $target) {
        Remove-Item -LiteralPath $target -Recurse -Force
    }

    robocopy $source $target /E /XF *.meta | Out-Null
    if ($LASTEXITCODE -ge 8) {
        throw "Failed to install $($item.Name). robocopy exit code: $LASTEXITCODE"
    }

    Write-Host "Installed $($item.Name) -> $target"
}
