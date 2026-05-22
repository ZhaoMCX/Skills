param(
    [Parameter(Mandatory = $true)]
    [ValidateSet("AgentFramework", "UnitySkills", "UniAppSkills")]
    [string]$Topic,

    [string]$OutputRoot = "dist\topics"
)

$ErrorActionPreference = "Stop"

$repoRoot = Split-Path -Parent $PSScriptRoot
$skillsRoot = Join-Path $repoRoot "skills"

$topics = @{
    AgentFramework = @{
        Description = "AgentFramework workflow skills for planning, execution, debugging, review, and verification."
        Skills = @(
            "using-agent-framework",
            "agent-framework",
            "af-create-framework",
            "af-update-framework",
            "af-plan-feature",
            "af-save-plan",
            "af-execute-plan",
            "af-debug",
            "af-review",
            "af-verify-completion",
            "dispatch-agents",
            "handoff"
        )
    }
    UnitySkills = @{
        Description = "Unity-focused Agent skills for common Unity development workflows."
        Skills = @(
            "unity-dotween",
            "unity-odin"
        )
    }
    UniAppSkills = @{
        Description = "uni-app Agent skills for App, H5, mini-program, and DCloud workflows."
        Skills = @(
            "uniapp-development",
            "wechat-miniprogram-devtools"
        )
    }
}

if (-not (Test-Path -LiteralPath $skillsRoot)) {
    throw "Missing skills directory: $skillsRoot"
}

$outputRootPath = if ([System.IO.Path]::IsPathRooted($OutputRoot)) {
    $OutputRoot
} else {
    Join-Path $repoRoot $OutputRoot
}

$topicConfig = $topics[$Topic]
$target = Join-Path $outputRootPath $Topic
$targetSkills = Join-Path $target "skills"
$targetScripts = Join-Path $target "scripts"

if (Test-Path -LiteralPath $target) {
    Remove-Item -LiteralPath $target -Recurse -Force
}

New-Item -ItemType Directory -Force -Path $targetSkills | Out-Null
New-Item -ItemType Directory -Force -Path $targetScripts | Out-Null

foreach ($skill in $topicConfig.Skills) {
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

$skillList = ($topicConfig.Skills | ForEach-Object { "- ``$_``" }) -join [Environment]::NewLine

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
    Replace("{{DESCRIPTION}}", $topicConfig.Description).
    Replace("{{SKILL_LIST}}", $skillList)

$readme | Set-Content -LiteralPath (Join-Path $target "README.md") -Encoding UTF8

Write-Host "Exported $Topic -> $target"
