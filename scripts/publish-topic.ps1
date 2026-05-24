param(
    [Parameter(Mandatory = $true)]
    [string]$Topic,

    [string]$OutputRoot = "dist\topics",

    [string]$Message
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

$topicDir = Resolve-TopicDirectory $Topic
$topicConfig = Read-TopicToml (Join-Path $topicDir.FullName "topic.toml")
$repository = $topicConfig.repository
$commitMessage = if ($Message) { $Message } else { "Sync $($topicConfig.name) from AgentSkills" }

$outputRootPath = if ([System.IO.Path]::IsPathRooted($OutputRoot)) {
    $OutputRoot
} else {
    Join-Path $repoRoot $OutputRoot
}

$target = Join-Path $outputRootPath $topicConfig.name

gh repo view $repository *> $null
if ($LASTEXITCODE -ne 0) {
    gh repo create $repository --public --description $topicConfig.description | Out-Host
}

& (Join-Path $PSScriptRoot "sync-topics.ps1") -Topic $topicConfig.slug -OutputRoot $OutputRootPath
& (Join-Path $PSScriptRoot "export-topic.ps1") -Topic $topicConfig.slug -OutputRoot $OutputRootPath -PreserveGit

git -C $target add . | Out-Host

$status = git -C $target status --short
if (-not $status) {
    Write-Host "No changes to publish for $($topicConfig.name)."
    exit 0
}

git -C $target commit -m $commitMessage | Out-Host
git -C $target push -u origin main | Out-Host

Write-Host "Published $($topicConfig.name) -> https://github.com/$repository"
