param(
    [string]$OutputRoot = "dist\topics",

    [string]$Message
)

$ErrorActionPreference = "Stop"

$repoRoot = Split-Path -Parent $PSScriptRoot
$skillsRoot = Join-Path $repoRoot "skills"

$topics = Get-ChildItem -LiteralPath $skillsRoot -Directory | Where-Object {
    Test-Path -LiteralPath (Join-Path $_.FullName "topic.toml")
} | Sort-Object Name

foreach ($topic in $topics) {
    Write-Host "Publishing $($topic.Name)..."
    $args = @{
        Topic = $topic.Name
        OutputRoot = $OutputRoot
    }

    if ($Message) {
        $args.Message = $Message
    }

    & (Join-Path $PSScriptRoot "publish-topic.ps1") @args
}
