param(
    [string]$Category,
    [string]$Skill,
    [string]$Destination = "$env:USERPROFILE\.codex\skills"
)

$ErrorActionPreference = "Stop"

$repoRoot = Split-Path -Parent $PSScriptRoot
$skillsRoot = Join-Path $repoRoot "skills"

if (-not (Test-Path -LiteralPath $skillsRoot)) {
    throw "Missing skills directory: $skillsRoot"
}

function Get-CategoryDirectories {
    Get-ChildItem -LiteralPath $skillsRoot -Directory
}

function Resolve-CategoryDirectory([string]$Name) {
    $categories = @(Get-CategoryDirectories)
    foreach ($categoryDir in $categories) {
        if ($categoryDir.Name -eq $Name) {
            return $categoryDir
        }
    }

    $available = ($categories | ForEach-Object { $_.Name } | Sort-Object) -join ", "
    throw "Unknown category '$Name'. Available categories: $available"
}

function Get-SkillDirectories([System.IO.DirectoryInfo[]]$CategoryDirs) {
    foreach ($categoryDir in $CategoryDirs) {
        Get-ChildItem -LiteralPath $categoryDir.FullName -Recurse -Directory | Where-Object {
            (Test-Path -LiteralPath (Join-Path $_.FullName "SKILL.md")) -and
            (-not (Test-Path -LiteralPath (Join-Path $_.Parent.FullName "SKILL.md")))
        }
    }
}

New-Item -ItemType Directory -Force -Path $Destination | Out-Null

$categoryDirs = if ($Category) { @(Resolve-CategoryDirectory $Category) } else { @(Get-CategoryDirectories) }
$skills = @(Get-SkillDirectories $categoryDirs)

if ($Skill) {
    $skills = @($skills | Where-Object { $_.Name -eq $Skill })
    if ($skills.Count -eq 0) {
        throw "Unknown skill '$Skill'."
    }
    if ($skills.Count -gt 1) {
        throw "Skill '$Skill' exists in multiple categories. Pass -Category to disambiguate."
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
