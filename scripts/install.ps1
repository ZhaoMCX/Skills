param(
    [string]$Topic,
    [string]$Skill,
    [string]$Destination = "$env:USERPROFILE\.codex\skills"
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

if (-not (Test-Path -LiteralPath $skillsRoot)) {
    throw "Missing skills directory: $skillsRoot"
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

function Get-SkillDirectories([System.IO.DirectoryInfo[]]$TopicDirs) {
    foreach ($topicDir in $TopicDirs) {
        Get-ChildItem -LiteralPath $topicDir.FullName -Directory | Where-Object {
            Test-Path -LiteralPath (Join-Path $_.FullName "SKILL.md")
        }
    }
}

New-Item -ItemType Directory -Force -Path $Destination | Out-Null

$topicDirs = if ($Topic) { @(Resolve-TopicDirectory $Topic) } else { @(Get-TopicDirectories) }
$skills = @(Get-SkillDirectories $topicDirs)

if ($Skill) {
    $skills = @($skills | Where-Object { $_.Name -eq $Skill })
    if ($skills.Count -eq 0) {
        throw "Unknown skill '$Skill'."
    }
    if ($skills.Count -gt 1) {
        throw "Skill '$Skill' exists in multiple topics. Pass -Topic to disambiguate."
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
