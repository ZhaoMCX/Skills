$ErrorActionPreference = "Stop"

$repoRoot = Split-Path -Parent $PSScriptRoot
$skillsRoot = Join-Path $repoRoot "skills"
$errors = New-Object System.Collections.Generic.List[string]
$skillNames = New-Object System.Collections.Generic.HashSet[string]

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

if (-not (Test-Path -LiteralPath $skillsRoot)) {
    throw "Missing skills directory: $skillsRoot"
}

$isTopicPackage = $true
foreach ($child in Get-ChildItem -LiteralPath $skillsRoot -Directory) {
    if (Test-Path -LiteralPath (Join-Path $child.FullName "topic.toml")) {
        $isTopicPackage = $false
        break
    }
}

if ((-not $isTopicPackage) -and (Test-Path -LiteralPath (Join-Path $repoRoot "topics.json"))) {
    $errors.Add("Root topics.json is deprecated; use skills/<topic>/topic.toml instead.")
}

if ($isTopicPackage) {
    foreach ($skill in Get-ChildItem -LiteralPath $skillsRoot -Directory) {
        $skillFile = Join-Path $skill.FullName "SKILL.md"

        if (-not (Test-Path $skillFile)) {
            $errors.Add("Missing SKILL.md: $($skill.Name)")
            continue
        }

        if (-not $skillNames.Add($skill.Name)) {
            $errors.Add("Duplicate skill name: $($skill.Name)")
        }

        $content = Get-Content -Raw -Encoding UTF8 -LiteralPath $skillFile

        if ($content -notmatch "(?s)^---\s.*?name:\s*$([regex]::Escape($skill.Name))\s") {
            $errors.Add("SKILL.md name does not match directory: $($skill.Name)")
        }

        if ($content -notmatch "(?s)^---\s.*?description:\s*.+") {
            $errors.Add("Missing description in SKILL.md: $($skill.Name)")
        }
    }
} else {
foreach ($topic in Get-ChildItem -LiteralPath $skillsRoot -Directory) {
    $topicFile = Join-Path $topic.FullName "topic.toml"
    if (-not (Test-Path -LiteralPath $topicFile)) {
        $errors.Add("Missing topic.toml: $($topic.Name)")
        continue
    }

    try {
        $topicConfig = Read-TopicToml $topicFile
        if (-not $topicConfig.name) { $errors.Add("Missing topic name: $($topic.Name)") }
        if (-not $topicConfig.slug) { $errors.Add("Missing topic slug: $($topic.Name)") }
        if (-not $topicConfig.repository) { $errors.Add("Missing topic repository: $($topic.Name)") }
        if (-not $topicConfig.description) { $errors.Add("Missing topic description: $($topic.Name)") }
        if ($topicConfig.slug -and $topicConfig.slug -ne $topic.Name) {
            $errors.Add("topic.toml slug does not match directory: $($topic.Name)")
        }
    } catch {
        $errors.Add("Invalid topic.toml: $($topic.Name) - $($_.Exception.Message)")
    }

    foreach ($skill in Get-ChildItem -LiteralPath $topic.FullName -Directory) {
        $skillFile = Join-Path $skill.FullName "SKILL.md"

        if (-not (Test-Path $skillFile)) {
            $errors.Add("Missing SKILL.md: $($topic.Name)/$($skill.Name)")
            continue
        }

        if (-not $skillNames.Add($skill.Name)) {
            $errors.Add("Duplicate skill name: $($skill.Name)")
        }

        $content = Get-Content -Raw -Encoding UTF8 -LiteralPath $skillFile

        if ($content -notmatch "(?s)^---\s.*?name:\s*$([regex]::Escape($skill.Name))\s") {
            $errors.Add("SKILL.md name does not match directory: $($topic.Name)/$($skill.Name)")
        }

        if ($content -notmatch "(?s)^---\s.*?description:\s*.+") {
            $errors.Add("Missing description in SKILL.md: $($topic.Name)/$($skill.Name)")
        }
    }
}
}

$metaFiles = Get-ChildItem -LiteralPath $skillsRoot -Recurse -Force -Filter *.meta
foreach ($meta in $metaFiles) {
    $errors.Add("Unexpected Unity .meta file: $($meta.FullName)")
}

foreach ($oldSkill in @("dispatch-agents", "handoff")) {
    if ($skillNames.Contains($oldSkill)) {
        $errors.Add("Deprecated general skill still present: $oldSkill")
    }
}

foreach ($requiredAfSkill in @("af-dispatch-agents", "af-handoff")) {
    if (-not $skillNames.Contains($requiredAfSkill)) {
        $errors.Add("Missing required AF skill: $requiredAfSkill")
    }
}

$afRoot = Join-Path $skillsRoot "agent-framework"
if (Test-Path -LiteralPath $afRoot) {
    $oldRefs = rg -n 'general `?(dispatch-agents|handoff)`?|`dispatch-agents`|`handoff`' $afRoot 2>$null
    foreach ($oldRef in $oldRefs) {
        $errors.Add("Deprecated AF reference: $oldRef")
    }
}

if ($errors.Count -gt 0) {
    $errors | ForEach-Object { Write-Error $_ }
    exit 1
}

Write-Host "All skills passed validation."
