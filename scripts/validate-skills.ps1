$ErrorActionPreference = "Stop"

$repoRoot = Split-Path -Parent $PSScriptRoot
$skillsRoot = Join-Path $repoRoot "skills"
$errors = New-Object System.Collections.Generic.List[string]

foreach ($skill in Get-ChildItem -LiteralPath $skillsRoot -Directory) {
    $skillFile = Join-Path $skill.FullName "SKILL.md"

    if (-not (Test-Path $skillFile)) {
        $errors.Add("Missing SKILL.md: $($skill.Name)")
        continue
    }

    $content = Get-Content -Raw -LiteralPath $skillFile

    if ($content -notmatch "(?s)^---\s.*?name:\s*$([regex]::Escape($skill.Name))\s") {
        $errors.Add("SKILL.md name does not match directory: $($skill.Name)")
    }

    if ($content -notmatch "(?s)^---\s.*?description:\s*.+") {
        $errors.Add("Missing description in SKILL.md: $($skill.Name)")
    }
}

$metaFiles = Get-ChildItem -LiteralPath $skillsRoot -Recurse -Force -Filter *.meta
foreach ($meta in $metaFiles) {
    $errors.Add("Unexpected Unity .meta file: $($meta.FullName)")
}

if ($errors.Count -gt 0) {
    $errors | ForEach-Object { Write-Error $_ }
    exit 1
}

Write-Host "All skills passed validation."
