$ErrorActionPreference = "Stop"

$repoRoot = Split-Path -Parent $PSScriptRoot
$skillsRoot = Join-Path $repoRoot "skills"
$errors = New-Object System.Collections.Generic.List[string]
$skillNames = New-Object System.Collections.Generic.HashSet[string]
$skillRelativeLinks = New-Object System.Collections.Generic.List[string]
$maxSkillLines = 120

function Add-Error([string]$Message) {
    $errors.Add($Message)
}

function Get-RelativePath([string]$Path) {
    $rootPath = (Resolve-Path -LiteralPath $repoRoot).Path.TrimEnd("\") + "\"
    $targetPath = (Resolve-Path -LiteralPath $Path).Path
    $rootUri = [System.Uri]::new($rootPath)
    $targetUri = [System.Uri]::new($targetPath)
    return [System.Uri]::UnescapeDataString($rootUri.MakeRelativeUri($targetUri).ToString()).Replace("/", "/")
}

function Test-Slug([string]$Value) {
    return $Value -match "^[a-z0-9]+(-[a-z0-9]+)*$"
}

function Get-Frontmatter([string]$Content, [string]$SkillLabel) {
    $frontmatterMatch = [regex]::Match($Content, "(?s)^---\r?\n(.*?)\r?\n---\r?\n")
    if (-not $frontmatterMatch.Success) {
        Add-Error "Missing opening frontmatter block: $SkillLabel"
        return $null
    }

    $matches = [regex]::Matches($Content, "(?m)^---\s*$")
    if ($matches.Count -lt 2) {
        Add-Error "Incomplete frontmatter block: $SkillLabel"
    }
    elseif ($matches[0].Index -ne 0) {
        Add-Error "Frontmatter must start at first byte: $SkillLabel"
    }

    return $frontmatterMatch.Groups[1].Value
}

function Get-FrontmatterValue([string]$Frontmatter, [string]$Key) {
    $match = [regex]::Match($Frontmatter, "(?m)^$([regex]::Escape($Key)):\s*(.+?)\s*$")
    if (-not $match.Success) {
        return $null
    }

    $value = $match.Groups[1].Value.Trim()
    if (($value.StartsWith('"') -and $value.EndsWith('"')) -or ($value.StartsWith("'") -and $value.EndsWith("'"))) {
        $value = $value.Substring(1, $value.Length - 2)
    }
    return $value
}

function Test-ReferencedFiles([string]$Content, [string]$SkillDir, [string]$SkillLabel) {
    $patterns = @(
        '\]\((references/[^)#\s]+\.md)(?:#[^)]+)?\)',
        '`(references/[^`\s]+\.md)`'
    )

    foreach ($pattern in $patterns) {
        foreach ($match in [regex]::Matches($Content, $pattern)) {
            $ref = $match.Groups[1].Value
            $target = Join-Path $SkillDir $ref
            if (-not (Test-Path -LiteralPath $target)) {
                Add-Error "Missing referenced file in ${SkillLabel}: $ref"
            }
        }
    }
}

if (-not (Test-Path -LiteralPath $skillsRoot)) {
    throw "Missing skills directory: $skillsRoot"
}

$skillDirs = @(Get-ChildItem -LiteralPath $skillsRoot -Directory | Where-Object {
    Test-Path -LiteralPath (Join-Path $_.FullName "SKILL.md")
})

if ($skillDirs.Count -eq 0) {
    Add-Error "No flat skill directories found under skills/."
}

$nestedSkillFiles = @(Get-ChildItem -LiteralPath $skillsRoot -Recurse -Filter SKILL.md | Where-Object {
    $_.Directory.Parent.FullName -ne $skillsRoot
})
foreach ($nestedSkillFile in $nestedSkillFiles) {
    Add-Error "Nested skill directory is not allowed: $(Get-RelativePath $nestedSkillFile.Directory.FullName)"
}

$nonSkillTopDirs = @(Get-ChildItem -LiteralPath $skillsRoot -Directory | Where-Object {
    -not (Test-Path -LiteralPath (Join-Path $_.FullName "SKILL.md"))
})
foreach ($dir in $nonSkillTopDirs) {
    Add-Error "Top-level directory under skills/ must be a skill: $(Get-RelativePath $dir.FullName)"
}

foreach ($skill in $skillDirs) {
    $relativeSkillPath = Get-RelativePath $skill.FullName
    $skillLabel = $relativeSkillPath.Substring("skills/".Length)
    $skillFile = Join-Path $skill.FullName "SKILL.md"

    if (-not (Test-Slug $skill.Name)) {
        Add-Error "Skill directory is not a slug: $skillLabel"
    }

    if (-not $skillNames.Add($skill.Name)) {
        Add-Error "Duplicate skill name: $($skill.Name)"
    }

    $lines = @(Get-Content -Encoding UTF8 -LiteralPath $skillFile)
    if ($lines.Count -gt $maxSkillLines) {
        Add-Error "SKILL.md exceeds $maxSkillLines lines ($($lines.Count)): ${skillLabel}"
    }

    $content = Get-Content -Raw -Encoding UTF8 -LiteralPath $skillFile
    $frontmatter = Get-Frontmatter $content $skillLabel
    if ($null -eq $frontmatter) {
        continue
    }

    $name = Get-FrontmatterValue $frontmatter "name"
    $description = Get-FrontmatterValue $frontmatter "description"

    if ([string]::IsNullOrWhiteSpace($name)) {
        Add-Error "Missing name in SKILL.md: $skillLabel"
    }
    elseif ($name -ne $skill.Name) {
        Add-Error "SKILL.md name does not match directory: $skillLabel"
    }
    elseif (-not (Test-Slug $name)) {
        Add-Error "SKILL.md name is not a slug: $skillLabel"
    }

    if ([string]::IsNullOrWhiteSpace($description)) {
        Add-Error "Missing description in SKILL.md: $skillLabel"
    }
    elseif ($description.Length -gt 1024) {
        Add-Error "Description exceeds 1024 chars: $skillLabel"
    }

    Test-ReferencedFiles $content $skill.FullName $skillLabel
    $skillRelativeLinks.Add($relativeSkillPath) | Out-Null
}

foreach ($name in @("README.md", "README.en.md")) {
    $readmePath = Join-Path $repoRoot $name
    if (-not (Test-Path -LiteralPath $readmePath)) {
        Add-Error "Missing $name"
        continue
    }

    $readme = Get-Content -Raw -Encoding UTF8 -LiteralPath $readmePath
    foreach ($link in $skillRelativeLinks) {
        $escapedLink = [regex]::Escape($link)
        $linkPattern = '\]\(' + $escapedLink + '\)'
        if ($readme -notmatch $linkPattern) {
            Add-Error "$name is missing link to $link"
        }
    }

    foreach ($match in [regex]::Matches($readme, '\]\((skills/[^)#\s]+)\)')) {
        $target = Join-Path $repoRoot $match.Groups[1].Value
        if (-not (Test-Path -LiteralPath $target)) {
            Add-Error "$name links to missing skill path: $($match.Groups[1].Value)"
        }
    }
}

$forbiddenPatterns = @("*.meta", ".DS_Store", "Thumbs.db", "*.log", ".env")
foreach ($pattern in $forbiddenPatterns) {
    $files = @(Get-ChildItem -LiteralPath $skillsRoot -Recurse -Force -File -Filter $pattern)
    foreach ($file in $files) {
        Add-Error "Unexpected generated/environment file: $(Get-RelativePath $file.FullName)"
    }
}

foreach ($dirName in @("node_modules", "__pycache__")) {
    $dirs = @(Get-ChildItem -LiteralPath $skillsRoot -Recurse -Force -Directory -Filter $dirName)
    foreach ($dir in $dirs) {
        Add-Error "Unexpected generated directory: $(Get-RelativePath $dir.FullName)"
    }
}

if ($errors.Count -gt 0) {
    $errors | ForEach-Object { Write-Error $_ }
    exit 1
}

Write-Host "All skills passed validation."
