#Requires -Version 7.0

<#
.SYNOPSIS
    Re-runs the C# generator under debugger against a previously generated test project.

.DESCRIPTION
    After running GenerateFromSpec.ps1, this script re-runs ONLY the C# generator
    (skipping the TypeSpec emitter) with --debug, which causes the generator to pause
    and wait for a debugger to attach. The emitter's outputs (tspCodeModel.json,
    Configuration.json) from the first run are reused as inputs.

    Workflow:
      1. Run GenerateFromSpec.ps1 to generate the code model and SDK
      2. Run this script — the generator will pause waiting for debugger
      3. In VS Code: Ctrl+Shift+P > ".NET: Attach to a .NET 5+ Process"
      4. Pick the dotnet process, set breakpoints, continue

.PARAMETER ProjectName
    Name of the test project under TestProjects/Local/ (e.g., "StorageActions").

.PARAMETER SkipBuild
    Skip rebuilding the generator before debugging.

.EXAMPLE
    .\DebugGenerator.ps1 -p StorageActions
#>
param(
    [Parameter(Mandatory = $true)]
    [Alias("p")]
    [string]$ProjectName,
    [switch]$SkipBuild
)

Import-Module "$PSScriptRoot\Generation.psm1" -DisableNameChecking -Force

$mgmtPackageRoot = Resolve-Path (Join-Path $PSScriptRoot '..' '..')
$generatorDir = Join-Path $mgmtPackageRoot 'generator'
$testProjectsLocalDir = Join-Path $generatorDir 'TestProjects' 'Local'
$projectDir = Join-Path $testProjectsLocalDir $ProjectName

# ── 1. Validate the test project has code model inputs ─────────────────────────
if (-not (Test-Path (Join-Path $projectDir "tspCodeModel.json"))) {
    Write-Error "No tspCodeModel.json found in '$projectDir'. Run GenerateFromSpec.ps1 first."
    exit 1
}

if (-not (Test-Path (Join-Path $projectDir "Configuration.json"))) {
    Write-Error "No Configuration.json found in '$projectDir'. Run GenerateFromSpec.ps1 first."
    exit 1
}

# ── 2. Build the generator ────────────────────────────────────────────────────
if (-not $SkipBuild) {
    Write-Host "Building generator..." -ForegroundColor Cyan
    Invoke "dotnet build $mgmtPackageRoot/generator/Azure.Generator.Management/src"
    if ($LASTEXITCODE -ne 0) {
        Write-Error "Generator build failed."
        exit $LASTEXITCODE
    }
}

# ── 3. Locate the generator DLL ───────────────────────────────────────────────
$generatorDll = Join-Path $mgmtPackageRoot "dist" "generator" "Microsoft.TypeSpec.Generator.dll"
if (-not (Test-Path $generatorDll)) {
    Write-Error "Generator DLL not found at '$generatorDll'. Build the generator first."
    exit 1
}

# ── 4. Launch the generator with --debug ──────────────────────────────────────
Write-Host ""
Write-Host "Launching generator with --debug (will wait for debugger)..." -ForegroundColor Yellow

$args = @("--roll-forward", "Major", $generatorDll, $projectDir, "-g", "ManagementClientGenerator", "--new-project", "--debug")
$proc = Start-Process -FilePath "dotnet" -ArgumentList $args -NoNewWindow -PassThru

Write-Host ""
Write-Host "  ► Generator PID: $($proc.Id)" -ForegroundColor Green
Write-Host "  ► VS Code: Ctrl+Shift+P > '.NET: Attach to a .NET 5+ Process' > pick PID $($proc.Id)" -ForegroundColor Yellow
Write-Host ""

$proc.WaitForExit()
exit $proc.ExitCode
