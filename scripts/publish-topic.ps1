param(
    [Parameter(Mandatory = $true)]
    [string]$Topic,

    [string]$OutputRoot = "dist\topics",

    [string]$Message
)

$ErrorActionPreference = "Stop"

$repoRoot = Split-Path -Parent $PSScriptRoot
$topicsFile = Join-Path $repoRoot "topics.json"

if (-not (Test-Path -LiteralPath $topicsFile)) {
    throw "Missing topics manifest: $topicsFile"
}

$topics = Get-Content -Raw -LiteralPath $topicsFile | ConvertFrom-Json
$topicConfig = $topics.PSObject.Properties[$Topic]

if ($null -eq $topicConfig) {
    $available = ($topics.PSObject.Properties.Name | Sort-Object) -join ", "
    throw "Unknown topic '$Topic'. Available topics: $available"
}

$repository = $topicConfig.Value.repository
$commitMessage = if ($Message) { $Message } else { "Sync $Topic from AgentSkills" }

$outputRootPath = if ([System.IO.Path]::IsPathRooted($OutputRoot)) {
    $OutputRoot
} else {
    Join-Path $repoRoot $OutputRoot
}

$target = Join-Path $outputRootPath $Topic

$description = $topicConfig.Value.description
gh repo view $repository *> $null
if ($LASTEXITCODE -ne 0) {
    gh repo create $repository --public --description $description | Out-Host
}

& (Join-Path $PSScriptRoot "sync-topics.ps1") -Topic $Topic -OutputRoot $OutputRootPath
& (Join-Path $PSScriptRoot "export-topic.ps1") -Topic $Topic -OutputRoot $OutputRootPath -PreserveGit

git -C $target add . | Out-Host

$status = git -C $target status --short
if (-not $status) {
    Write-Host "No changes to publish for $Topic."
    exit 0
}

git -C $target commit -m $commitMessage | Out-Host
git -C $target push -u origin main | Out-Host

Write-Host "Published $Topic -> https://github.com/$repository"
