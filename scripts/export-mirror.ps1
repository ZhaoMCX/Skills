param(
    [Parameter(Mandatory = $true)]
    [string]$Skill,

    [string]$OutputRoot = "dist\mirrors",

    [string]$RepositoryName
)

$ErrorActionPreference = "Stop"

$repoRoot = Split-Path -Parent $PSScriptRoot
$source = Join-Path $repoRoot "skills\$Skill"

if (-not (Test-Path (Join-Path $source "SKILL.md"))) {
    throw "Unknown skill or missing SKILL.md: $Skill"
}

$outputRootPath = if ([System.IO.Path]::IsPathRooted($OutputRoot)) {
    $OutputRoot
} else {
    Join-Path $repoRoot $OutputRoot
}

$repoName = if ($RepositoryName) { $RepositoryName } else { $Skill }
$target = Join-Path $outputRootPath $repoName

if (Test-Path $target) {
    Remove-Item -LiteralPath $target -Recurse -Force
}

New-Item -ItemType Directory -Force -Path $target | Out-Null
robocopy $source $target /E /XF *.meta | Out-Null
if ($LASTEXITCODE -ge 8) {
    throw "Failed to export $Skill. robocopy exit code: $LASTEXITCODE"
}

if (-not (Test-Path (Join-Path $target "README.md"))) {
    $title = ($Skill -split "-") | ForEach-Object {
        if ($_.Length -gt 0) { $_.Substring(0, 1).ToUpperInvariant() + $_.Substring(1) }
    }
    $title = $title -join " "

    @"
# $title

Standalone mirror of the `$Skill` Codex skill.

## Install

Copy this directory to:

```text
%USERPROFILE%\.codex\skills\$Skill
```

Or install from the source monorepo with:

```powershell
.\scripts\install.ps1 -Skill $Skill
```
"@ | Set-Content -LiteralPath (Join-Path $target "README.md") -Encoding UTF8
}

Write-Host "Exported $Skill -> $target"
