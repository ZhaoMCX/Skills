param(
    [string]$Topic,

    [string]$OutputRoot = "dist\topics"
)

$ErrorActionPreference = "Stop"

$repoRoot = Split-Path -Parent $PSScriptRoot
$topicsFile = Join-Path $repoRoot "topics.json"

if (-not (Test-Path -LiteralPath $topicsFile)) {
    throw "Missing topics manifest: $topicsFile"
}

$topics = Get-Content -Raw -LiteralPath $topicsFile | ConvertFrom-Json
$topicNames = if ($Topic) {
    if ($null -eq $topics.PSObject.Properties[$Topic]) {
        $available = ($topics.PSObject.Properties.Name | Sort-Object) -join ", "
        throw "Unknown topic '$Topic'. Available topics: $available"
    }
    @($Topic)
} else {
    @($topics.PSObject.Properties.Name | Sort-Object)
}

$outputRootPath = if ([System.IO.Path]::IsPathRooted($OutputRoot)) {
    $OutputRoot
} else {
    Join-Path $repoRoot $OutputRoot
}

New-Item -ItemType Directory -Force -Path $outputRootPath | Out-Null

foreach ($topicName in $topicNames) {
    $topicConfig = $topics.PSObject.Properties[$topicName].Value
    $repository = $topicConfig.repository
    $target = Join-Path $outputRootPath $topicName
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

    Write-Host "Synced $topicName -> $target"
}
