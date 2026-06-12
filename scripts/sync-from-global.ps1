param(
    [string]$Skill,
    [string]$Source = "$env:USERPROFILE\.codex\skills",
    [switch]$IncludeAgentMetadata
)

$ErrorActionPreference = "Stop"

$repoRoot = Split-Path -Parent $PSScriptRoot
$skillsRoot = Join-Path $repoRoot "skills"

if (-not (Test-Path -LiteralPath $skillsRoot)) {
    throw "Missing skills directory: $skillsRoot"
}

if (-not (Test-Path -LiteralPath $Source)) {
    throw "Missing global skills directory: $Source"
}

function Get-SkillDirectories {
    Get-ChildItem -LiteralPath $skillsRoot -Directory | Where-Object {
        Test-Path -LiteralPath (Join-Path $_.FullName "SKILL.md")
    }
}

$skills = @(Get-SkillDirectories)

if ($Skill) {
    $skills = @($skills | Where-Object { $_.Name -eq $Skill })
    if ($skills.Count -eq 0) {
        throw "Unknown repository skill '$Skill'."
    }
}

$synced = 0
$skipped = 0

foreach ($item in $skills) {
    $sourceSkill = Join-Path $Source $item.Name
    $sourceSkillFile = Join-Path $sourceSkill "SKILL.md"

    if (-not (Test-Path -LiteralPath $sourceSkillFile)) {
        $skipped += 1
        Write-Host "Skipped $($item.Name): no matching global skill at $sourceSkill"
        continue
    }

    $target = $item.FullName

    if (Test-Path -LiteralPath $target) {
        Remove-Item -LiteralPath $target -Recurse -Force
    }

    New-Item -ItemType Directory -Force -Path $target | Out-Null

    $robocopyArgs = @($sourceSkill, $target, "/E", "/XF", "*.meta")
    if (-not $IncludeAgentMetadata) {
        $robocopyArgs += @("/XD", "agents")
    }

    robocopy @robocopyArgs | Out-Null
    if ($LASTEXITCODE -ge 8) {
        throw "Failed to sync $($item.Name). robocopy exit code: $LASTEXITCODE"
    }

    $synced += 1
    Write-Host "Synced $($item.Name): $sourceSkill -> $target"
}

Write-Host "Done. Synced: $synced. Skipped: $skipped."
exit 0
