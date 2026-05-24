param(
    [string]$Topic,

    [string]$OutputRoot = "dist\topics"
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

$topicDirs = if ($Topic) { @(Resolve-TopicDirectory $Topic) } else { @(Get-TopicDirectories | Sort-Object Name) }

$outputRootPath = if ([System.IO.Path]::IsPathRooted($OutputRoot)) {
    $OutputRoot
} else {
    Join-Path $repoRoot $OutputRoot
}

New-Item -ItemType Directory -Force -Path $outputRootPath | Out-Null

foreach ($topicDir in $topicDirs) {
    $topicConfig = Read-TopicToml (Join-Path $topicDir.FullName "topic.toml")
    $repository = $topicConfig.repository
    $target = Join-Path $outputRootPath $topicConfig.name
    $remoteUrl = "https://github.com/$repository.git"

    if (Test-Path -LiteralPath $target) {
        if (-not (Test-Path -LiteralPath (Join-Path $target ".git"))) {
            throw "Topic workspace exists but is not a Git repository: $target"
        }

        $status = git -C $target status --porcelain
        if ($status) {
            throw "Topic workspace has uncommitted changes: $target"
        }

        $currentRemote = git -C $target remote get-url origin
        if ($currentRemote -ne $remoteUrl) {
            git -C $target remote set-url origin $remoteUrl | Out-Host
        }

        git -C $target fetch origin main | Out-Host
        git -C $target checkout main | Out-Host
        git -C $target pull --ff-only origin main | Out-Host
    } else {
        git clone $remoteUrl $target | Out-Host
    }

    Write-Host "Synced $($topicConfig.name) -> $target"
}
