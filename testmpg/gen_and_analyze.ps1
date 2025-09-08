param(
    [Parameter(Position=0, Mandatory=$false)]
    [string]$InputFile
)

if (-not $InputFile) {
    Write-Error "Usage: .\gen_and_analyze.ps1 <input-file>"
    exit 1
}

if (-not (Test-Path $InputFile)) {
    Write-Error "Input file '$InputFile' not found."
    exit 1
}

#global variables
$parsingCommit = $true
$specRepo = 'D:\work\spec'


# ----------------
# Helper functions
# ----------------

function Ensure-TspConfigHttpClient {
    param(
        [Parameter(Mandatory=$true)] [string]$TspConfigFile,
        [Parameter(Mandatory=$true)] [string]$SpecPath
    )

    if (-not (Test-Path $TspConfigFile -PathType Leaf)) {
        Write-Host "   tspconfig.yaml not found at $TspConfigFile; skipping tspconfig update" -ForegroundColor Yellow
        return $false
    }

    # Require YAML cmdlets for structured updates; throw if not present
    $canYaml = (Get-Command ConvertFrom-Yaml -ErrorAction SilentlyContinue) -ne $null -and (Get-Command ConvertTo-Yaml -ErrorAction SilentlyContinue) -ne $null
    if (-not $canYaml) {
        throw "YAML cmdlets ConvertFrom-Yaml/ConvertTo-Yaml are not available in this session. Install PowerShell-Yaml module or run in PowerShell 7.2+ with yaml support."
    }

    try {
        $yamlObj = Get-Content -Path $TspConfigFile -Raw | ConvertFrom-Yaml
        if ($yamlObj.options -and $yamlObj.options.'@azure-typespec/http-client-csharp-mgmt') {
            Write-Host "   tspconfig.yaml already contains @azure-typespec/http-client-csharp-mgmt" -ForegroundColor Yellow
            return $true
        }

        Write-Host "   Adding @azure-typespec/http-client-csharp-mgmt block (YAML) to $TspConfigFile" -ForegroundColor Green
        $pkgName = ''
        if ($yamlObj.options -and $yamlObj.options.'@azure-tools/typespec-csharp') {
            $tools = $yamlObj.options.'@azure-tools/typespec-csharp'
            if ($tools.'package-dir') { $pkgName = $tools.'package-dir' }
            elseif ($tools.'namespace') { $pkgName = $tools.'namespace' }
        }
        if (-not $pkgName) { $pkgName = Split-Path $SpecPath -Leaf }
        if (-not $yamlObj.options) { $yamlObj.options = @{} }
        $yamlObj.options.'@azure-typespec/http-client-csharp-mgmt' = @{ 'package-name' = $pkgName; 'namespace' = '{package-name}'; 'new-project' = $false }
        $yamlObj | ConvertTo-Yaml | Out-File -FilePath $TspConfigFile -Encoding utf8
        Write-Host "   Updated $TspConfigFile (YAML serialized)" -ForegroundColor Green
        return $true
    }
    catch {
        throw ("Failed to parse/serialize YAML at {0}: {1}" -f $TspConfigFile, $_)
    }
}

function Get-TspLocationInfo {
    param(
        [Parameter(Mandatory=$true)] [string]$TspFile,
        [Parameter(Mandatory=$true)] [bool]$ParsingCommit
    )

    $result = @{ SpecRelative = $null; CommitId = $null }
    if (-not (Test-Path $TspFile)) { return $result }

    $lines = Get-Content -Path $TspFile -ErrorAction SilentlyContinue
    foreach ($l in $lines) {
        $trim = $l.Trim()
        if ($ParsingCommit -and ($trim -match '^(commitId|commit|ref)\s*:\s*(.+)$')) {
            $result.CommitId = $Matches[2].Trim().Trim("'", '"')
        }
        if ($trim -match '^directory\s*:\s*(.+)$') {
            $val = $Matches[1].Trim()
            $val = $val.Trim("'", '"')
            $result.SpecRelative = $val
        }
    }

    return $result
}

function Set-TspConfigHttpClient {
    param(
        [Parameter(Mandatory=$true)] [string]$TspConfigFile,
        [Parameter(Mandatory=$true)] [string]$SpecPath
    )

    if (-not (Test-Path $TspConfigFile -PathType Leaf)) {
        Write-Host "   tspconfig.yaml not found at $TspConfigFile; skipping tspconfig update" -ForegroundColor Yellow
        return $false
    }

    # Require YAML cmdlets for structured updates; throw if not present
    $convertFrom = Get-Command ConvertFrom-Yaml -ErrorAction SilentlyContinue
    $convertTo = Get-Command ConvertTo-Yaml -ErrorAction SilentlyContinue
    $canYaml = ($null -ne $convertFrom) -and ($null -ne $convertTo)
    if (-not $canYaml) {
        throw "YAML cmdlets ConvertFrom-Yaml/ConvertTo-Yaml are not available in this session. Install PowerShell-Yaml module or run in PowerShell 7.2+ with yaml support."
    }

    try {
        $yamlObj = Get-Content -Path $TspConfigFile -Raw | ConvertFrom-Yaml
        if ($yamlObj.options -and $yamlObj.options.'@azure-typespec/http-client-csharp-mgmt') {
            Write-Host "   tspconfig.yaml already contains @azure-typespec/http-client-csharp-mgmt" -ForegroundColor Yellow
            return $true
        }

        Write-Host "   Adding @azure-typespec/http-client-csharp-mgmt block (YAML) to $TspConfigFile" -ForegroundColor Green
        $pkgName = ''
        if ($yamlObj.options -and $yamlObj.options.'@azure-tools/typespec-csharp') {
            $tools = $yamlObj.options.'@azure-tools/typespec-csharp'
            if ($tools.'package-dir') { $pkgName = $tools.'package-dir' }
            elseif ($tools.'namespace') { $pkgName = $tools.'namespace' }
        }
        if (-not $pkgName) { $pkgName = Split-Path $SpecPath -Leaf }
        if (-not $yamlObj.options) { $yamlObj.options = @{} }
        $yamlObj.options.'@azure-typespec/http-client-csharp-mgmt' = @{ 'package-name' = $pkgName; 'namespace' = '{package-name}'; 'new-project' = $false }
        $yamlObj | ConvertTo-Yaml | Out-File -FilePath $TspConfigFile -Encoding utf8
        Write-Host "   Updated $TspConfigFile (YAML serialized)" -ForegroundColor Green
        return $true
    }
    catch {
        throw ("Failed to parse/serialize YAML at {0}: {1}" -f $TspConfigFile, $_)
    }
}

function Add-TspEmitterLine {
    param(
        [Parameter(Mandatory=$true)] [string]$TspFile,
        [Parameter(Mandatory=$true)] [string]$EmitterLine
    )

    if (-not (Test-Path $TspFile -PathType Leaf)) {
        Write-Host "   tsp-location.yaml not found: $TspFile" -ForegroundColor Yellow
        return $false
    }

    $content = Get-Content -Path $TspFile -Raw -ErrorAction SilentlyContinue
    if ($content -match 'emitterPackageJsonPath\s*:') {
        Write-Host "   emitterPackageJsonPath already present in $TspFile" -ForegroundColor Yellow
        return $true
    }

    Write-Host "   Adding emitterPackageJsonPath to $TspFile" -ForegroundColor Green
    # Ensure the emitter line is appended on its own line. If the file doesn't end with a newline,
    # prepend a CRLF so the emitter line is on a new line.
    # Simplified behavior: if the file doesn't end with a newline, prepend CRLF so the emitter
    # line is appended on its own line; otherwise append directly. No special-casing for empty files.
    $toAdd = if ($content -notmatch "(\r?\n)$") { "`r`n$EmitterLine" } else { $EmitterLine }

    Add-Content -Path $TspFile -Value $toAdd
    return $true
}

function Set-SpecRepoCommit {
    param(
        [Parameter(Mandatory=$true)] [string]$SpecRepoPath,
        [Parameter(Mandatory=$true)] [string]$CommitId
    )

    # Ensure the spec repo is a git repository
    if (-not (Test-Path (Join-Path $SpecRepoPath '.git'))) {
        Write-Host "   $SpecRepoPath is not a git repository; skipping checkout" -ForegroundColor Yellow
        return $false
    }

    try {
    # First, clean any local modifications that may have been left by previous SDK runs
    Write-Host "   Cleaning working tree in $SpecRepoPath (git checkout .)" -ForegroundColor Cyan
    $cleanupOut = & git -C $SpecRepoPath checkout . 2>&1
    foreach ($o in $cleanupOut) { Write-Host "     $o" -ForegroundColor DarkGray }

    Write-Host "   Found commit/ref '$CommitId' in tsp-location.yaml; attempting checkout in $SpecRepoPath" -ForegroundColor Cyan
    $fetchOut = & git -C $SpecRepoPath fetch --all --tags 2>&1
    foreach ($o in $fetchOut) { Write-Host "     $o" -ForegroundColor DarkGray }
    $checkoutOut = & git -C $SpecRepoPath checkout $CommitId 2>&1
        if ($LASTEXITCODE -ne 0) {
            Write-Host "   git checkout failed: $checkoutOut" -ForegroundColor Red
            return $false
        }
        else {
            Write-Host "   Checked out '$CommitId' in $SpecRepoPath" -ForegroundColor Green
            return $true
        }
    }
    catch {
        Write-Host "   Exception during git operations: $_" -ForegroundColor Red
        return $false
    }
}

# Pre-generation: ensure dated reports directory exists under script's reports folder
$today = Get-Date -Format "yyyy-MM-dd"
$scriptRoot = Split-Path -Parent $MyInvocation.MyCommand.Definition
$reportsBase = Join-Path $scriptRoot 'reports'
$reportDir = Join-Path $reportsBase $today
if (-not (Test-Path $reportDir)) {
    New-Item -ItemType Directory -Path $reportDir -Force | Out-Null
    Write-Host "Created report directory: $reportDir" -ForegroundColor Green
}
else {
    Write-Host "Using existing report directory: $reportDir" -ForegroundColor Cyan
}

Write-Host "Reading SDK repo paths from '$InputFile'..." -ForegroundColor Cyan

foreach ($raw in (Get-Content -Path $InputFile)) {
    $line = $raw.Trim()
    if ($line -eq '') { continue }
    if ($line -match '^[\s]*(#|//|;)' ) { continue }
    if ($line -match '^[Rr]esults generated on') { continue }
    # Print the SDK repo path
    Write-Host $line -ForegroundColor Cyan
    # Step 2: check tsp-location.yaml and ensure emitterPackageJsonPath is present
    $sdkPath = $line
    if (-not (Test-Path $sdkPath)) {
        Write-Warning "Path not found: $sdkPath"
        continue
    }

    # Pre-generation per-service report directory:
    # derive serviceName as the path segment immediately after 'sdk'
    $serviceName = $null
    $tokens = $sdkPath -split '[\\/]'
    for ($i = 0; $i -lt $tokens.Length; $i++) {
        if ($tokens[$i].ToLower() -eq 'sdk' -and ($i + 1) -lt $tokens.Length) {
            $serviceName = $tokens[$i + 1]
            break
        }
    }
    if (-not $serviceName) {
        # Could not derive serviceName; warn and skip this SDK path so we don't create invalid report dirs
        Write-Warning "   Could not derive service name for path: $sdkPath; skipping this entry."
        continue
    }

    $serviceReportDir = Join-Path $reportDir $serviceName
    if (-not (Test-Path $serviceReportDir)) {
        New-Item -ItemType Directory -Path $serviceReportDir -Force | Out-Null
        Write-Host "Created service report directory: $serviceReportDir" -ForegroundColor Green
    }
    else {
        Write-Host "Using existing service report directory: $serviceReportDir" -ForegroundColor Cyan
    }

    # Clean up per-service report directory before code generation
    try {
        Write-Host "   Cleaning service report directory: $serviceReportDir" -ForegroundColor Yellow
        Get-ChildItem -Path $serviceReportDir -Force -ErrorAction SilentlyContinue | ForEach-Object {
            try { Remove-Item -LiteralPath $_.FullName -Recurse -Force -ErrorAction SilentlyContinue } catch {}
        }
    }
    catch {
        Write-Host "   Failed to clean service report directory: $_" -ForegroundColor Red
    }

    $tspFile = Join-Path $sdkPath 'tsp-location.yaml'
    if (-not (Test-Path $tspFile -PathType Leaf)) {
        Write-Host "   tsp-location.yaml not found in $sdkPath" -ForegroundColor Yellow
        continue
    }

    $emitterLine = 'emitterPackageJsonPath: "eng/azure-typespec-http-client-csharp-mgmt-emitter-package.json"'

    # Ensure the emitterPackageJsonPath entry exists; helper will append if missing
    Add-TspEmitterLine -TspFile $tspFile -EmitterLine $emitterLine | Out-Null

    # Step 3: read commit/ref and locate spec directory entry in tsp-location.yaml
    $parsed = Get-TspLocationInfo -TspFile $tspFile -ParsingCommit $parsingCommit
    $specRelative = $parsed.SpecRelative
    $commitId = $parsed.CommitId
    if ($commitId) { Write-Host "   Parsed commit/ref: $commitId" -ForegroundColor Magenta }

    # If commitId found and parsing is enabled, attempt to checkout that ref in $specRepo (if it's a git repo)
    if ($parsingCommit -and $commitId) {
        # Delegate git checkout to helper; it will output status and return $true/$false
        $checked = Set-SpecRepoCommit -SpecRepoPath $specRepo -CommitId $commitId
        if (-not $checked) {
            Write-Host "   Spec repo checkout failed or skipped for $commitId" -ForegroundColor Yellow
        }
    }

    if (-not $specRelative) {
        Write-Host "   No 'directory:' entry found in $tspFile" -ForegroundColor Yellow
    }
    else {
        # Combine with $specRepo (absolute base)
        $specPath = Join-Path $specRepo $specRelative
        # Normalize path
        $specPath = [System.IO.Path]::GetFullPath($specPath)
        if (Test-Path $specPath -PathType Container) {
            Write-Host "   Spec directory exists: $specPath" -ForegroundColor Green

            # Step 3.5: ensure tspconfig.yaml contains @azure-typespec/http-client-csharp-mgmt
            $tspConfigFile = Join-Path $specPath 'tspconfig.yaml'
            if (-not (Test-Path $tspConfigFile -PathType Leaf)) {
                Write-Host "   tspconfig.yaml not found at $tspConfigFile; skipping tspconfig update" -ForegroundColor Yellow
            }
            else {
                # Delegate tspconfig update to helper
                Set-TspConfigHttpClient -TspConfigFile $tspConfigFile -SpecPath $specPath | Out-Null
            }

            # Step 4: generate service SDK by running dotnet build in the SDK repo
            Write-Host "   Generating SDK for service (running dotnet build) in $sdkPath" -ForegroundColor Cyan
            Push-Location $sdkPath
            try {
                $dotnetArgs = @('build', '/t:GenerateCode', '--tl:off', '/P:SaveInputs=true', "/p:LocalSpecRepo=$specPath")
                Write-Host "   Executing: dotnet $($dotnetArgs -join ' ')" -ForegroundColor DarkCyan
                $dotnetOutput = & dotnet @dotnetArgs 2>&1
                $dotnetExit = $LASTEXITCODE
                foreach ($o in $dotnetOutput) { Write-Host "     $o" -ForegroundColor DarkGray }

                # After generation, check for emitter used in the generator output and abort if not expected
                $requiredPrefix = '@azure-typespec/http-client-csharp-mgmt'
                $emitterFound = $dotnetOutput | Where-Object { $_ -match 'Found emitter package\s+([^\s]+)' } | ForEach-Object { if ($_ -match 'Found emitter package\s+([^\s]+)') { $Matches[1] } }
                if ($emitterFound) {
                    foreach ($e in $emitterFound) {
                        if (-not ($e -like "$requiredPrefix*")) {
                            Write-Host "   Wrong emitter used for generation: $e (required prefix: $requiredPrefix). Aborting." -ForegroundColor Red
                            exit 2
                        }
                    }
                }
                # Persist generation log immediately
                if ($serviceReportDir) {
                    $reportFile = Join-Path $serviceReportDir 'generate.log'
                    $dotnetOutput | Out-File -FilePath $reportFile -Encoding utf8
                    Write-Host "   Saved generation log: $reportFile" -ForegroundColor Cyan
                }

                # If generation (GenerateCode) failed, record per-service failure and continue to next SDK
                if ($dotnetExit -ne 0) {
                    Write-Host "   dotnet build (generation) failed with exit code $dotnetExit; marking service as failed and continuing." -ForegroundColor Red

                    if ($serviceReportDir) {
                        $summaryFile = Join-Path $serviceReportDir 'summary.md'
                        $emitterText = '-' 
                        if ($emitterFound) { $emitterText = ($emitterFound -join ', ') }
                        $summaryLines = @()
                        $summaryLines += "# Summary for $serviceName"
                        $summaryLines += "Service: $serviceName"
                        $summaryLines += "ReportDir: $serviceReportDir"
                        $summaryLines += "Emitter package: $emitterText"
                        $summaryLines += "Generation succeeded: False"
                        $summaryLines += "Build succeeded: False"
                        $summaryLines -join "`n" | Out-File -FilePath $summaryFile -Encoding utf8
                        Write-Host "   Wrote summary: $summaryFile" -ForegroundColor Cyan
                    }

                    # Continue processing next SDK in the input list instead of terminating the whole run
                    continue
                }
                else {
                    Write-Host "   dotnet build completed successfully" -ForegroundColor Green
                }

                # Step 5: verify the generated code by running dotnet build
                if ($serviceReportDir) {
                    Write-Host "   Verifying generated code (dotnet build) in $sdkPath" -ForegroundColor Cyan
                    $dotnetVerifyArgs = @('build')
                    $dotnetVerifyOutput = & dotnet @dotnetVerifyArgs 2>&1
                    $dotnetVerifyExit = $LASTEXITCODE
                    foreach ($o in $dotnetVerifyOutput) { Write-Host "     $o" -ForegroundColor DarkGray }

                    if ($dotnetVerifyExit -ne 0) {
                        Write-Host "   dotnet build (verification) failed with exit code $dotnetVerifyExit" -ForegroundColor Red
                    }
                    else {
                        Write-Host "   dotnet build (verification) completed successfully" -ForegroundColor Green
                    }

                    $verifyFile = Join-Path $serviceReportDir 'build.log'
                    $dotnetVerifyOutput | Out-File -FilePath $verifyFile -Encoding utf8
                    Write-Host "   Saved build verification log: $verifyFile" -ForegroundColor Cyan

                    # Generate per-service post-generation report
                    $postGenScript = Join-Path $scriptRoot 'post_gen_report.ps1'
                    if (Test-Path $postGenScript) {
                        try {
                            Write-Host "   Running post-generation report script for $serviceName" -ForegroundColor Cyan
                            & pwsh -NoProfile -ExecutionPolicy Bypass -File $postGenScript -ServiceReportDir $serviceReportDir -ServiceName $serviceName
                        }
                        catch {
                            Write-Host "   Post-generation report script failed: $_" -ForegroundColor Yellow
                        }
                    }
                }
            }
            finally {
                Pop-Location
            }
        }
        else {
            Write-Host "   Spec directory NOT found: $specPath" -ForegroundColor Red
        }
    }
}
