param(
    [Parameter(Mandatory = $true)]
    [string]$Topic,

    [string]$OutputRoot = "dist\topics",

    [switch]$PreserveGit
)

$ErrorActionPreference = "Stop"

$repoRoot = Split-Path -Parent $PSScriptRoot
$skillsRoot = Join-Path $repoRoot "skills"
$topicsFile = Join-Path $repoRoot "topics.json"

if (-not (Test-Path -LiteralPath $topicsFile)) {
    throw "Missing topics manifest: $topicsFile"
}

$topics = Get-Content -Raw -LiteralPath $topicsFile | ConvertFrom-Json
$topicProperty = $topics.PSObject.Properties[$Topic]

if (-not (Test-Path -LiteralPath $skillsRoot)) {
    throw "Missing skills directory: $skillsRoot"
}

if ($null -eq $topicProperty) {
    $available = ($topics.PSObject.Properties.Name | Sort-Object) -join ", "
    throw "Unknown topic '$Topic'. Available topics: $available"
}

$outputRootPath = if ([System.IO.Path]::IsPathRooted($OutputRoot)) {
    $OutputRoot
} else {
    Join-Path $repoRoot $OutputRoot
}

$topicConfig = $topicProperty.Value
$target = Join-Path $outputRootPath $Topic
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

foreach ($skill in $topicConfig.skills) {
    $source = Join-Path $skillsRoot $skill
    $destination = Join-Path $targetSkills $skill

    if (-not (Test-Path -LiteralPath (Join-Path $source "SKILL.md"))) {
        throw "Topic $Topic references missing skill: $skill"
    }

    robocopy $source $destination /E /XF *.meta | Out-Null
    if ($LASTEXITCODE -ge 8) {
        throw "Failed to export $skill. robocopy exit code: $LASTEXITCODE"
    }
}

Copy-Item -LiteralPath (Join-Path $repoRoot ".gitignore") -Destination (Join-Path $target ".gitignore")
Copy-Item -LiteralPath (Join-Path $repoRoot "scripts\install.ps1") -Destination (Join-Path $targetScripts "install.ps1")
Copy-Item -LiteralPath (Join-Path $repoRoot "scripts\validate-skills.ps1") -Destination (Join-Path $targetScripts "validate-skills.ps1")

$skillList = ($topicConfig.skills | ForEach-Object { "- ``$_``" }) -join [Environment]::NewLine

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
    Replace("{{TOPIC}}", $Topic).
    Replace("{{DESCRIPTION}}", $topicConfig.description).
    Replace("{{SKILL_LIST}}", $skillList)

$readme | Set-Content -LiteralPath (Join-Path $target "README.md") -Encoding UTF8

Write-Host "Exported $Topic -> $target"
