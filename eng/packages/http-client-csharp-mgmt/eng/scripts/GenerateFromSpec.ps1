#Requires -Version 7.0

<#
.SYNOPSIS
    Generates a management SDK from a service spec as a local test project.

.DESCRIPTION
    Copies a service spec from an external spec repo into a new test project under
    TestProjects/Local/, creates the necessary configuration, runs the TypeSpec compiler
    with the management emitter, and builds the generated C# project.

.PARAMETER SpecPath
    Path to the service spec directory containing main.tsp (and optionally client.tsp).
    Example: D:\work\spec\specification\storageactions\StorageAction.Management

.PARAMETER ProjectName
    Optional name for the test project directory. Defaults to the spec folder name.

.PARAMETER SkipBuild
    Skip rebuilding the emitter and generator before generation.

.PARAMETER SkipDotnetBuild
    Skip building the generated C# project after generation.

.EXAMPLE
    .\GenerateFromSpec.ps1 -SpecPath D:\work\spec\specification\storageactions\StorageAction.Management

.EXAMPLE
    .\GenerateFromSpec.ps1 -SpecPath D:\work\spec\specification\storageactions\StorageAction.Management -ProjectName StorageActions -SkipBuild
#>
param(
    [Parameter(Mandatory = $true)]
    [string]$SpecPath,
    [Alias("p")]
    [string]$ProjectName,
    [switch]$SkipBuild,
    [switch]$SkipDotnetBuild
)

Import-Module "$PSScriptRoot\Generation.psm1" -DisableNameChecking -Force

$mgmtPackageRoot = Resolve-Path (Join-Path $PSScriptRoot '..' '..')
$testProjectsLocalDir = Join-Path $mgmtPackageRoot 'generator' 'TestProjects' 'Local'

# ── 1. Validate spec path ──────────────────────────────────────────────────────
$SpecPath = Resolve-Path $SpecPath -ErrorAction Stop
if (-not (Test-Path (Join-Path $SpecPath "main.tsp"))) {
    Write-Error "No main.tsp found in '$SpecPath'. Please provide a valid TypeSpec spec directory."
    exit 1
}

Write-Host "Spec path: $SpecPath" -ForegroundColor Cyan

# ── 2. Determine project name ──────────────────────────────────────────────────
if (-not $ProjectName) {
    $ProjectName = Split-Path $SpecPath -Leaf
}

Write-Host "Project name: $ProjectName" -ForegroundColor Cyan

# ── 3. Extract namespace from spec's tspconfig.yaml ────────────────────────────
$specTspConfig = Join-Path $SpecPath "tspconfig.yaml"
$namespace = $null

if (Test-Path $specTspConfig) {
    $configContent = Get-Content $specTspConfig -Raw

    # Try to extract namespace from @azure-typespec/http-client-csharp-mgmt options
    if ($configContent -match '@azure-typespec/http-client-csharp-mgmt[^@]*?namespace:\s*"([^"]+)"') {
        $namespace = $Matches[1]
    }
    # Fallback: try @azure-tools/typespec-csharp options (older format)
    elseif ($configContent -match '@azure-tools/typespec-csharp[^@]*?namespace:\s*"([^"]+)"') {
        $namespace = $Matches[1]
    }
}

if (-not $namespace) {
    # Derive namespace from the spec's armProviderNamespace
    $mainTsp = Get-Content (Join-Path $SpecPath "main.tsp") -Raw
    if ($mainTsp -match 'namespace\s+([\w.]+)\s*[;{]') {
        $providerNamespace = $Matches[1]
        # Convert e.g. "Microsoft.StorageActions" -> "Azure.ResourceManager.StorageActions"
        $serviceName = $providerNamespace -replace '^Microsoft\.', ''
        $namespace = "Azure.ResourceManager.$serviceName"
    }
    else {
        Write-Error "Could not determine namespace from spec. Please ensure the spec has a tspconfig.yaml with namespace or a main.tsp with a namespace declaration."
        exit 1
    }
}

Write-Host "Namespace: $namespace" -ForegroundColor Cyan

# ── 4. Create test project directory ───────────────────────────────────────────
$projectDir = Join-Path $testProjectsLocalDir $ProjectName

if (Test-Path $projectDir) {
    Write-Host "Project directory already exists, cleaning Generated/ folder..." -ForegroundColor Yellow
    $generatedDir = Join-Path $projectDir "src" "Generated"
    if (Test-Path $generatedDir) {
        Remove-Item $generatedDir -Recurse -Force
    }
}
else {
    New-Item -ItemType Directory -Path $projectDir -Force | Out-Null
}

Write-Host "Project directory: $projectDir" -ForegroundColor Cyan

# ── 5. Copy spec files ─────────────────────────────────────────────────────────
Write-Host "Copying spec files..." -ForegroundColor Cyan

# Copy all .tsp files
Get-ChildItem -Path $SpecPath -Filter "*.tsp" -File | ForEach-Object {
    Copy-Item $_.FullName -Destination $projectDir -Force
}

# Copy examples directory if it exists (some specs reference examples)
$examplesDir = Join-Path $SpecPath "examples"
if (Test-Path $examplesDir) {
    $destExamples = Join-Path $projectDir "examples"
    if (Test-Path $destExamples) {
        Remove-Item $destExamples -Recurse -Force
    }
    Copy-Item $examplesDir -Destination $projectDir -Recurse -Force
}

# ── 6. Create tspconfig.yaml ──────────────────────────────────────────────────
Write-Host "Creating tspconfig.yaml..." -ForegroundColor Cyan

$tspConfigContent = @"
emit:
  - "@azure-typespec/http-client-csharp-mgmt"
options:
  "@azure-typespec/http-client-csharp-mgmt":
    namespace: "$namespace"
"@

Set-Content -Path (Join-Path $projectDir "tspconfig.yaml") -Value $tspConfigContent -NoNewline

# ── 7. Determine entry point ──────────────────────────────────────────────────
# Prefer client.tsp if it exists (it imports main.tsp and adds @@clientName decorators)
$entryPoint = "main.tsp"
if (Test-Path (Join-Path $projectDir "client.tsp")) {
    $entryPoint = "client.tsp"
}

Write-Host "Entry point: $entryPoint" -ForegroundColor Cyan

# ── 8. Build emitter and generator ────────────────────────────────────────────
if (-not $SkipBuild) {
    Refresh-Mgmt-Build
    if ($LASTEXITCODE -ne 0) {
        Write-Error "Build failed."
        exit $LASTEXITCODE
    }
}

# ── 9. Run TypeSpec generation ─────────────────────────────────────────────────
Write-Host "Generating SDK for $ProjectName..." -ForegroundColor Cyan

$specFile = Join-Path $projectDir $entryPoint
$command = Get-Mgmt-TspCommand $specFile $projectDir

Invoke $command

if ($LASTEXITCODE -ne 0) {
    Write-Error "Generation failed."
    exit $LASTEXITCODE
}

Write-Host "Generation complete!" -ForegroundColor Green

# ── 10. Build the generated project ───────────────────────────────────────────
if (-not $SkipDotnetBuild) {
    # Find the generated .csproj
    $csproj = Get-ChildItem -Path (Join-Path $projectDir "src") -Filter "*.csproj" -File | Select-Object -First 1

    if ($csproj) {
        Write-Host "Building $($csproj.Name)..." -ForegroundColor Cyan
        Invoke "dotnet build $($csproj.FullName)"
        if ($LASTEXITCODE -ne 0) {
            Write-Error "Build failed."
            exit $LASTEXITCODE
        }
        Write-Host "Build succeeded!" -ForegroundColor Green
    }
    else {
        Write-Warning "No .csproj found in $projectDir/src/. The generator may not have created one."
    }
}

Write-Host ""
Write-Host "═══════════════════════════════════════════════════════════════" -ForegroundColor Green
Write-Host " SDK generated at: $projectDir" -ForegroundColor Green
Write-Host "═══════════════════════════════════════════════════════════════" -ForegroundColor Green
