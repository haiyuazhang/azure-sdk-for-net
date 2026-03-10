#Requires -Version 7.0

<#
.SYNOPSIS
    Re-runs the TypeSpec emitter under Node.js debugger against a test project.

.DESCRIPTION
    After running GenerateFromSpec.ps1 to create a test project, this script re-runs
    the TypeSpec compiler + emitter with Node.js --inspect-brk, which pauses at startup
    waiting for a debugger to attach on port 9229.

    In VS Code, the debugger auto-detects and prompts to attach, or you can manually:
      Ctrl+Shift+P > "Debug: Attach to Node Process"

    Set breakpoints in emitter/src/*.ts files (source maps are enabled).

.PARAMETER ProjectName
    Name of the test project under TestProjects/Local/ (e.g., "StorageActions").

.PARAMETER SkipBuild
    Skip rebuilding the emitter before debugging.

.PARAMETER Port
    Node.js debug port. Defaults to 9229.

.EXAMPLE
    .\DebugEmitter.ps1 -p StorageActions
#>
param(
    [Parameter(Mandatory = $true)]
    [Alias("p")]
    [string]$ProjectName,
    [switch]$SkipBuild,
    [int]$Port = 9229
)

Import-Module "$PSScriptRoot\Generation.psm1" -DisableNameChecking -Force

$mgmtPackageRoot = Resolve-Path (Join-Path $PSScriptRoot '..' '..')
$generatorDir = Join-Path $mgmtPackageRoot 'generator'
$testProjectsLocalDir = Join-Path $generatorDir 'TestProjects' 'Local'
$projectDir = Join-Path $testProjectsLocalDir $ProjectName

# ── 1. Validate the test project exists ────────────────────────────────────────
if (-not (Test-Path (Join-Path $projectDir "main.tsp")) -and -not (Test-Path (Join-Path $projectDir "client.tsp"))) {
    Write-Error "No .tsp files found in '$projectDir'. Run GenerateFromSpec.ps1 first."
    exit 1
}

# ── 2. Build the emitter ──────────────────────────────────────────────────────
if (-not $SkipBuild) {
    Write-Host "Building emitter..." -ForegroundColor Cyan
    Invoke "npm run build:emitter" $mgmtPackageRoot
    if ($LASTEXITCODE -ne 0) {
        Write-Error "Emitter build failed."
        exit $LASTEXITCODE
    }
}

# ── 3. Determine entry point ──────────────────────────────────────────────────
$entryPoint = "main.tsp"
if (Test-Path (Join-Path $projectDir "client.tsp")) {
    $entryPoint = "client.tsp"
}

# ── 4. Build the tsp compile command (reuse existing helper) ──────────────────
$specFile = Join-Path $projectDir $entryPoint
$command = Get-Mgmt-TspCommand $specFile $projectDir

# ── 5. Launch with NODE_OPTIONS=--inspect-brk ─────────────────────────────────
Write-Host ""
Write-Host "Launching emitter with --inspect-brk on port $Port..." -ForegroundColor Yellow
Write-Host ""
Write-Host "  ► VS Code should auto-detect. If not:" -ForegroundColor Yellow
Write-Host "    Ctrl+Shift+P > 'Debug: Attach to Node Process'" -ForegroundColor Yellow
Write-Host "  ► Set breakpoints in emitter/src/*.ts" -ForegroundColor Yellow
Write-Host ""

$env:NODE_OPTIONS = "--inspect-brk=$Port"
try {
    Invoke $command
}
finally {
    $env:NODE_OPTIONS = $null
}
