param(
    [Parameter(Mandatory = $true)]
    [string]$Topic,

    [string]$OutputRoot = "dist\topics",

    [switch]$PreserveGit
)

$ErrorActionPreference = "Stop"

$repoRoot = Split-Path -Parent $PSScriptRoot
$skillsRoot = Join-Path $repoRoot "skills"

function Read-TopicToml([string]$Path) {
    $result = @{}
    foreach ($line in Get-Content -Encoding UTF8 -LiteralPath $Path) {
        $trimmed = $line.Trim()
        if (-not $trimmed -or $trimmed.StartsWith("#")) { continue }
        if ($trimmed -match '^([A-Za-z0-9_-]+)\s*=\s*"(.*)"\s*$') {
            $result[$matches[1]] = $matches[2]
        } elseif ($trimmed -match '^([A-Za-z0-9_-]+)\s*=\s*\[(.*)\]\s*$') {
            $items = @()
            $rawItems = $matches[2].Split(",")
            foreach ($item in $rawItems) {
                $value = $item.Trim().Trim('"')
                if ($value) { $items += $value }
            }
            $result[$matches[1]] = $items
        }
    }
    [pscustomobject]$result
}

function Get-TopicDirectories {
    Get-ChildItem -LiteralPath $skillsRoot -Directory | Where-Object {
        Test-Path -LiteralPath (Join-Path $_.FullName "topic.toml")
    }
}

function Resolve-TopicDirectory([string]$Name) {
    $topics = @(Get-TopicDirectories)
    foreach ($topic in $topics) {
        $config = Read-TopicToml (Join-Path $topic.FullName "topic.toml")
        $aliases = @($config.aliases)
        if ($topic.Name -eq $Name -or $config.slug -eq $Name -or $config.name -eq $Name -or $aliases -contains $Name) {
            return $topic
        }
    }

    $available = ($topics | ForEach-Object { $_.Name } | Sort-Object) -join ", "
    throw "Unknown topic '$Name'. Available topics: $available"
}

if (-not (Test-Path -LiteralPath $skillsRoot)) {
    throw "Missing skills directory: $skillsRoot"
}

$topicDir = Resolve-TopicDirectory $Topic
$topicConfig = Read-TopicToml (Join-Path $topicDir.FullName "topic.toml")

$outputRootPath = if ([System.IO.Path]::IsPathRooted($OutputRoot)) {
    $OutputRoot
} else {
    Join-Path $repoRoot $OutputRoot
}

$target = Join-Path $outputRootPath $topicConfig.name
$targetSkills = Join-Path $target "skills"
$targetScripts = Join-Path $target "scripts"

if (Test-Path -LiteralPath $target) {
    if ($PreserveGit -and (Test-Path -LiteralPath (Join-Path $target ".git"))) {
        Get-ChildItem -LiteralPath $target -Force | Where-Object { $_.Name -ne ".git" } | ForEach-Object {
            Remove-Item -LiteralPath $_.FullName -Recurse -Force
        }
    } else {
        Remove-Item -LiteralPath $target -Recurse -Force
    }
}

New-Item -ItemType Directory -Force -Path $targetSkills | Out-Null
New-Item -ItemType Directory -Force -Path $targetScripts | Out-Null

$skillDirs = @(Get-ChildItem -LiteralPath $topicDir.FullName -Directory | Where-Object {
    Test-Path -LiteralPath (Join-Path $_.FullName "SKILL.md")
} | Sort-Object Name)

foreach ($skill in $skillDirs) {
    $destination = Join-Path $targetSkills $skill.Name

    robocopy $skill.FullName $destination /E /XF *.meta | Out-Null
    if ($LASTEXITCODE -ge 8) {
        throw "Failed to export $($skill.Name). robocopy exit code: $LASTEXITCODE"
    }
}

Copy-Item -LiteralPath (Join-Path $repoRoot ".gitignore") -Destination (Join-Path $target ".gitignore")
Copy-Item -LiteralPath (Join-Path $repoRoot "scripts\install.ps1") -Destination (Join-Path $targetScripts "install.ps1")
Copy-Item -LiteralPath (Join-Path $repoRoot "scripts\validate-skills.ps1") -Destination (Join-Path $targetScripts "validate-skills.ps1")

$skillList = ($skillDirs | ForEach-Object { "- ``$($_.Name)``" }) -join [Environment]::NewLine

$readmeTemplate = @'
# {{TOPIC}}

{{DESCRIPTION}}

This repository is generated from the `AgentSkills` source collection.

## Included Skills

{{SKILL_LIST}}

## Install For Codex

Install all skills from this repository into the local Codex skills directory:

```powershell
.\scripts\install.ps1
```

Install one skill:

```powershell
.\scripts\install.ps1 -Skill <skill-name>
```

## Validate

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File .\scripts\validate-skills.ps1
```
'@

$readme = $readmeTemplate.
    Replace("{{TOPIC}}", $topicConfig.name).
    Replace("{{DESCRIPTION}}", $topicConfig.description).
    Replace("{{SKILL_LIST}}", $skillList)

$readme | Set-Content -LiteralPath (Join-Path $target "README.md") -Encoding UTF8

Write-Host "Exported $($topicConfig.name) -> $target"
