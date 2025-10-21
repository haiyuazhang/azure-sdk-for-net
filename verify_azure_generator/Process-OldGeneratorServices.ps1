#!/usr/bin/env pwsh

<#
.SYNOPSIS
    Extracts and processes services from old TypeSpec generator migration

.DESCRIPTION
    This script can either extract services from Library_Inventory.md or process existing services.
    
    Step 0 (Extract): Extracts services from the "Data Plane Libraries using TypeSpec (Old Generator)" 
    section of Library_Inventory.md and saves to JSON file.
    
    Steps 1-8 (Process): Processes services from the JSON file to migrate them:
    1. Find the relative path and convert to absolute path
    2. Navigate to the service directory
    3. Update tsp-location.yaml
    4. Update .csproj file
    5. Checkout spec
    6. Update tspconfig.yaml
    7. Generate code
    8. Build code
    9. Generate report

.PARAMETER Mode
    Operation mode: 'Extract', 'Process', or 'Both'. 
    - Extract: Only extract services from Library_Inventory.md
    - Process: Only process existing services from JSON file
    - Both: Extract first, then process. Defaults to 'Both'.

.PARAMETER InputFile
    Path to the Library_Inventory.md file for extraction. Defaults to the standard location in the repository.

.PARAMETER ServicesJsonFile
    Path to the old-generator-services.json file. Defaults to "old-generator-services.json" in current directory.

.PARAMETER RepoRoot
    Root path of the repository. Defaults to "D:\work\sdk2".

.PARAMETER LogLevel
    Logging level: 'Verbose', 'Info', 'Warning', 'Error'. Defaults to 'Info'.

.PARAMETER ServiceFilter
    Optional filter to process only specific services. Supports wildcards.

.PARAMETER SkipSteps
    Array of step numbers to skip (0-9). Useful for debugging or partial runs.
    Step 0 = Extract services, Steps 1-9 = Process services

.EXAMPLE
    .\Process-OldGeneratorServices.ps1
    Extracts services and then processes them
    
.EXAMPLE
    .\Process-OldGeneratorServices.ps1 -Mode Extract
    Only extracts services to JSON file
    
.EXAMPLE
    .\Process-OldGeneratorServices.ps1 -Mode Process -ServiceFilter "communication*" -SkipSteps @(6,7)
    Only processes existing services with filter and skipped steps

.EXAMPLE
    .\Process-OldGeneratorServices.ps1 -ServicesJsonFile "custom-services.json" -RepoRoot "C:\MyRepo"
    Uses custom file paths
#>

param(
    [Parameter()]
    [ValidateSet('Extract', 'Process', 'Both')]
    [string]$Mode = 'Both',
    
    [Parameter()]
    [string]$InputFile = "$PSScriptRoot\..\doc\GeneratorMigration\Library_Inventory.md",
    
    [Parameter()]
    [string]$ServicesJsonFile = "old-generator-services.json",
    
    [Parameter()]
    [string]$RepoRoot = "D:\work\sdk2",
    
    [Parameter()]
    [ValidateSet('Verbose', 'Info', 'Warning', 'Error')]
    [string]$LogLevel = 'Info',
    
    [Parameter()]
    [string]$ServiceFilter,
    
    [Parameter()]
    [int[]]$SkipSteps = @()
)

# Global variables
$script:ProcessedServices = @()
$script:FailedServices = @()
$script:LogFile = Join-Path $PSScriptRoot "process-old-generator-services-$(Get-Date -Format 'yyyyMMdd-HHmmss').log"

#region Logging Functions
function Write-Log {
    param(
        [string]$Message,
        [ValidateSet('Verbose', 'Info', 'Warning', 'Error')]
        [string]$Level = 'Info',
        [string]$Service = $null
    )
    
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $logMessage = "[$timestamp] [$Level]"
    
    if ($Service) {
        $logMessage += " [$Service]"
    }
    
    $logMessage += " $Message"
    
    # Write to log file
    Add-Content -Path $LogFile -Value $logMessage
    
    # Write to console based on log level
    $shouldDisplay = switch ($LogLevel) {
        'Verbose' { $true }
        'Info' { $Level -ne 'Verbose' }
        'Warning' { $Level -in @('Warning', 'Error') }
        'Error' { $Level -eq 'Error' }
    }
    
    if ($shouldDisplay) {
        switch ($Level) {
            'Verbose' { Write-Host $logMessage -ForegroundColor Gray }
            'Info' { Write-Host $logMessage -ForegroundColor White }
            'Warning' { Write-Host $logMessage -ForegroundColor Yellow }
            'Error' { Write-Host $logMessage -ForegroundColor Red }
        }
    }
}

function Write-Step {
    param(
        [int]$StepNumber,
        [string]$StepName,
        [string]$Service
    )
    
    if ($StepNumber -in $SkipSteps) {
        Write-Log "SKIPPING Step ${StepNumber}: $StepName" -Level Warning -Service $Service
        return $false
    }
    
    Write-Log "Step ${StepNumber}: $StepName" -Level Info -Service $Service
    return $true
}
#endregion

#region Step 0 - Extract Services Functions
function Extract-OldGeneratorServices {
    param([string[]]$Content)
    
    $services = @()
    $inOldGeneratorSection = $false
    $inTable = $false
    
    foreach ($line in $Content) {
        # Check if we've reached the "Data Plane Libraries using TypeSpec (Old Generator)" section
        if ($line -match "^## Data Plane Libraries using TypeSpec \(Old Generator\)") {
            $inOldGeneratorSection = $true
            Write-Log "Found Old Generator section" -Level Verbose
            continue
        }
        
        # Check if we've reached the next section (exit the old generator section)
        if ($inOldGeneratorSection -and $line -match "^## ") {
            Write-Log "Exiting Old Generator section" -Level Verbose
            break
        }
        
        # Check if we're in the table header
        if ($inOldGeneratorSection -and $line -match "^\| Service \| Library \| Path \|") {
            $inTable = $true
            Write-Log "Found table header" -Level Verbose
            continue
        }
        
        # Skip the table separator line
        if ($inTable -and $line -match "^\| ------- \| ------- \| ---- \|") {
            continue
        }
        
        # Extract service data from table rows
        if ($inTable -and $line -match "^\| ([^|]+) \| ([^|]+) \| ([^|]+) \|") {
            $service = $matches[1].Trim()
            $library = $matches[2].Trim()
            $path = $matches[3].Trim()
            
            $serviceInfo = [PSCustomObject]@{
                Service = $service
                Library = $library
                Path = $path
            }
            
            $services += $serviceInfo
            Write-Log "Found service: $service" -Level Verbose
        }
    }
    
    return $services
}

function Step0-ExtractServices {
    if (-not (Write-Step -StepNumber 0 -StepName "Extract services from Library_Inventory.md" -Service "System")) {
        return $true
    }
    
    try {
        # Check if input file exists
        if (-not (Test-Path $InputFile)) {
            Write-Log "ERROR: Input file not found: $InputFile" -Level Error
            return $false
        }
        
        Write-Log "Reading Library_Inventory.md from: $InputFile" -Level Info
        
        # Read the content
        $content = Get-Content -Path $InputFile -Encoding UTF8
        
        # Extract services
        $services = Extract-OldGeneratorServices -Content $content
        
        if ($services.Count -eq 0) {
            Write-Log "WARNING: No services found in the Old Generator section" -Level Warning
            return $false
        }
        
        Write-Log "Found $($services.Count) services using TypeSpec (Old Generator)" -Level Info
        
        # Create JSON output
        $result = @{
            TotalCount = $services.Count
            UniqueServices = ($services.Service | Sort-Object -Unique)
            Libraries = $services
            ExtractionDate = Get-Date
            SourceFile = $InputFile
        }
        
        # Save to JSON file
        $result | ConvertTo-Json -Depth 3 | Set-Content -Path $ServicesJsonFile -Encoding UTF8
        Write-Log "Services extracted and saved to: $ServicesJsonFile" -Level Info
        
        # Summary
        $uniqueServiceCount = ($services.Service | Sort-Object -Unique).Count
        Write-Log "Extraction Summary:" -Level Info
        Write-Log "  Total libraries: $($services.Count)" -Level Info
        Write-Log "  Unique services: $uniqueServiceCount" -Level Info
        
        if ($uniqueServiceCount -gt 0) {
            Write-Log "Unique service names:" -Level Info
            $services.Service | Sort-Object -Unique | ForEach-Object { 
                Write-Log "  - $_" -Level Info
            }
        }
        
        return $true
    }
    catch {
        Write-Log "ERROR: Failed to extract services - $($_.Exception.Message)" -Level Error
        return $false
    }
}
#endregion

#region Service Processing Functions
function Step1-FindAndConvertPath {
    param(
        [PSCustomObject]$ServiceInfo
    )
    
    if (-not (Write-Step -StepNumber 1 -StepName "Find relative path and convert to absolute path" -Service $ServiceInfo.Service)) {
        return $null
    }
    
    $relativePath = $ServiceInfo.Path
    $absolutePath = Join-Path -Path $RepoRoot -ChildPath $relativePath
    
    Write-Log "Relative path: $relativePath" -Level Verbose -Service $ServiceInfo.Service
    Write-Log "Absolute path: $absolutePath" -Level Verbose -Service $ServiceInfo.Service
    
    if (-not (Test-Path $absolutePath)) {
        Write-Log "ERROR: Service directory does not exist: $absolutePath" -Level Error -Service $ServiceInfo.Service
        return $null
    }
    
    return $absolutePath
}

function Step2-NavigateToServiceDirectory {
    param(
        [string]$ServicePath,
        [string]$ServiceName
    )
    
    if (-not (Write-Step -StepNumber 2 -StepName "Navigate to service directory" -Service $ServiceName)) {
        return $false
    }
    
    try {
        Set-Location -Path $ServicePath
        Write-Log "Changed to directory: $ServicePath" -Level Verbose -Service $ServiceName
        return $true
    }
    catch {
        Write-Log "ERROR: Failed to navigate to directory $ServicePath - $($_.Exception.Message)" -Level Error -Service $ServiceName
        return $false
    }
}

function Step3-UpdateTspLocation {
    param(
        [string]$ServicePath,
        [string]$ServiceName
    )
    
    if (-not (Write-Step -StepNumber 3 -StepName "Update tsp-location.yaml" -Service $ServiceName)) {
        return $true
    }
    
    $tspLocationFile = Join-Path -Path $ServicePath -ChildPath "tsp-location.yaml"
    
    if (-not (Test-Path $tspLocationFile)) {
        Write-Log "WARNING: tsp-location.yaml not found at: $tspLocationFile" -Level Warning -Service $ServiceName
        return $false
    }
    
    try {
        # Read current content
        $content = Get-Content $tspLocationFile -Raw
        
        # Check if emitterPackageJsonPath already exists
        if ($content -match 'emitterPackageJsonPath\s*:') {
            Write-Log "emitterPackageJsonPath already exists in tsp-location.yaml" -Level Info -Service $ServiceName
            return $true
        }
        
        # Add emitterPackageJsonPath line
        $emitterLine = 'emitterPackageJsonPath: "eng/azure-typespec-http-client-csharp-emitter-package.json"'
        
        # If content doesn't end with newline, add one before our line
        if (-not $content.EndsWith("`n")) {
            $content += "`n"
        }
        
        # Add the emitter line
        $updatedContent = $content + $emitterLine + "`n"
        
        # Write back to file
        Set-Content -Path $tspLocationFile -Value $updatedContent -NoNewline
        Write-Log "Added emitterPackageJsonPath to tsp-location.yaml" -Level Info -Service $ServiceName
        return $true
    }
    catch {
        Write-Log "ERROR: Failed to update tsp-location.yaml - $($_.Exception.Message)" -Level Error -Service $ServiceName
        return $false
    }
}

function Step4-UpdateCsProject {
    param(
        [string]$ServicePath,
        [string]$ServiceName
    )
    
    if (-not (Write-Step -StepNumber 4 -StepName "Update .csproj file" -Service $ServiceName)) {
        return $true
    }
    
    # Find .csproj file in the service directory and subdirectories
    $csprojFiles = Get-ChildItem -Path $ServicePath -Filter "*.csproj" -File -Recurse
    
    if ($csprojFiles.Count -eq 0) {
        Write-Log "WARNING: No .csproj file found in: $ServicePath" -Level Warning -Service $ServiceName
        return $false
    }
    
    if ($csprojFiles.Count -gt 1) {
        Write-Log "WARNING: Multiple .csproj files found, using first one: $($csprojFiles[0].Name)" -Level Warning -Service $ServiceName
    }
    
    $csprojFile = $csprojFiles[0].FullName
    Write-Log "Found .csproj file: $csprojFile" -Level Verbose -Service $ServiceName
    
    try {
        # Read current content
        $content = Get-Content $csprojFile -Raw
        
        # Check if IncludeAutorestDependency already exists
        if ($content -match '<IncludeAutorestDependency>false</IncludeAutorestDependency>') {
            Write-Log "IncludeAutorestDependency already exists in .csproj file" -Level Info -Service $ServiceName
            return $true
        }
        
        # Add IncludeAutorestDependency line
        $newLine = '    <IncludeAutorestDependency>false</IncludeAutorestDependency>'
        
        # Find the first PropertyGroup to add the line
        if ($content -match '(<PropertyGroup[^>]*>)') {
            # Insert after the first PropertyGroup opening tag
            $insertPosition = $content.IndexOf($matches[1]) + $matches[1].Length
            $beforeInsert = $content.Substring(0, $insertPosition)
            $afterInsert = $content.Substring($insertPosition)
            
            # Add the new line with proper indentation
            $updatedContent = $beforeInsert + "`n" + $newLine + $afterInsert
            
            # Write back to file
            Set-Content -Path $csprojFile -Value $updatedContent -NoNewline
            Write-Log "Added IncludeAutorestDependency to .csproj file" -Level Info -Service $ServiceName
        } else {
            Write-Log "WARNING: Could not find PropertyGroup in .csproj file to add IncludeAutorestDependency" -Level Warning -Service $ServiceName
            return $false
        }
        return $true
    }
    catch {
        Write-Log "ERROR: Failed to update .csproj file - $($_.Exception.Message)" -Level Error -Service $ServiceName
        return $false
    }
}

function Step5-CheckoutSpec {
    param(
        [string]$ServicePath,
        [string]$ServiceName
    )
    
    if (-not (Write-Step -StepNumber 5 -StepName "Checkout spec" -Service $ServiceName)) {
        return $true
    }
    
    # Hard-coded spec repo root path
    $specRepoRoot = "D:\work\spec"
    
    # Find tsp-location.yaml file
    $tspLocationFile = Join-Path $ServicePath "tsp-location.yaml"
    
    if (-not (Test-Path $tspLocationFile)) {
        Write-Log "ERROR: tsp-location.yaml not found at: $tspLocationFile" -Level Error -Service $ServiceName
        return $false
    }
    
    try {
        # Read and parse tsp-location.yaml
        $tspLocationContent = Get-Content $tspLocationFile -Raw
        Write-Log "Reading tsp-location.yaml from: $tspLocationFile" -Level Verbose -Service $ServiceName
        
        # Extract values using regex
        $directoryMatch = [regex]::Match($tspLocationContent, "directory:\s*(.+)")
        $commitMatch = [regex]::Match($tspLocationContent, "commit:\s*(.+)")
        $repoMatch = [regex]::Match($tspLocationContent, "repo:\s*(.+)")
        
        if (-not $directoryMatch.Success -or -not $commitMatch.Success -or -not $repoMatch.Success) {
            Write-Log "ERROR: Could not parse required fields from tsp-location.yaml" -Level Error -Service $ServiceName
            return $false
        }
        
        $directory = $directoryMatch.Groups[1].Value.Trim()
        $commit = $commitMatch.Groups[1].Value.Trim()
        $repo = $repoMatch.Groups[1].Value.Trim()
        
        Write-Log "Parsed tsp-location.yaml - Directory: $directory, Commit: $commit, Repo: $repo" -Level Verbose -Service $ServiceName
        
        # Calculate spec directory path
        $specDirectory = Join-Path $specRepoRoot $directory
        Write-Log "Spec directory path: $specDirectory" -Level Verbose -Service $ServiceName
        
        # Check if spec repo root exists
        if (-not (Test-Path $specRepoRoot)) {
            Write-Log "ERROR: Spec repo root not found at: $specRepoRoot" -Level Error -Service $ServiceName
            return $false
        }
        
        # Change to spec repo directory
        $currentDir = Get-Location
        try {
            Set-Location $specRepoRoot
            Write-Log "Changed to spec repo directory: $specRepoRoot" -Level Verbose -Service $ServiceName
            
            # Check current commit
            $gitResult = & git rev-parse HEAD 2>&1
            if ($LASTEXITCODE -ne 0) {
                Write-Log "ERROR: Failed to get current commit - $gitResult" -Level Error -Service $ServiceName
                return $false
            }
            
            # Handle both string and array results from git command
            if ($gitResult -is [array]) {
                $currentCommit = $gitResult[0].ToString().Trim()
            } else {
                $currentCommit = $gitResult.ToString().Trim()
            }
            
            Write-Log "Current commit: $currentCommit" -Level Verbose -Service $ServiceName
            Write-Log "Target commit: $commit" -Level Verbose -Service $ServiceName
            
            # Skip checkout if already on the correct commit
            if ($currentCommit -eq $commit) {
                Write-Log "Already on target commit $commit, skipping checkout" -Level Info -Service $ServiceName
            } else {
                Write-Log "Need to checkout commit $commit (current: $currentCommit)" -Level Info -Service $ServiceName
                
                # Clean the repository before checkout
                Write-Log "Cleaning repository before checkout" -Level Info -Service $ServiceName
                
                # Reset all changes (staged and unstaged)
                Write-Log "Resetting all changes with git reset --hard HEAD" -Level Verbose -Service $ServiceName
                $gitResetResult = & git reset --hard HEAD 2>&1
                if ($LASTEXITCODE -ne 0) {
                    Write-Log "ERROR: Failed to reset repository - $gitResetResult" -Level Error -Service $ServiceName
                    return $false
                }
                
                # Clean untracked files and directories
                Write-Log "Cleaning untracked files with git clean -fd" -Level Verbose -Service $ServiceName
                $gitCleanResult = & git clean -fd 2>&1
                if ($LASTEXITCODE -ne 0) {
                    Write-Log "ERROR: Failed to clean untracked files - $gitCleanResult" -Level Error -Service $ServiceName
                    return $false
                }
                
                # Now attempt the checkout
                Write-Log "Attempting to checkout commit: $commit" -Level Info -Service $ServiceName
                $gitCheckoutResult = & git checkout $commit 2>&1
                if ($LASTEXITCODE -ne 0) {
                    Write-Log "ERROR: Failed to checkout commit $commit - $gitCheckoutResult" -Level Error -Service $ServiceName
                    return $false
                }
                
                Write-Log "Successfully checked out commit: $commit" -Level Info -Service $ServiceName
            }
            
            # Verify the spec directory exists
            if (-not (Test-Path $specDirectory)) {
                Write-Log "WARNING: Spec directory not found after checkout: $specDirectory" -Level Warning -Service $ServiceName
                return $false
            }
            
            Write-Log "Verified spec directory exists: $specDirectory" -Level Info -Service $ServiceName
        }
        finally {
            # Always return to original directory
            Set-Location $currentDir
        }
        
        return $true
    }
    catch {
        Write-Log "ERROR: Failed to checkout spec - $($_.Exception.Message)" -Level Error -Service $ServiceName
        return $false
    }
}

function Step6-UpdateTspConfig {
    param(
        [string]$ServicePath,
        [string]$ServiceName
    )
    
    if (-not (Write-Step -StepNumber 6 -StepName "Update tspconfig.yaml" -Service $ServiceName)) {
        return $true
    }
    
    # Hard-coded spec repo root path
    $specRepoRoot = "D:\work\spec"
    
    # Find tsp-location.yaml to get the spec directory
    $tspLocationFile = Join-Path $ServicePath "tsp-location.yaml"
    
    if (-not (Test-Path $tspLocationFile)) {
        Write-Log "ERROR: tsp-location.yaml not found at: $tspLocationFile" -Level Error -Service $ServiceName
        return $false
    }
    
    try {
        # Read and parse tsp-location.yaml to get the spec directory
        $tspLocationContent = Get-Content $tspLocationFile -Raw
        $directoryMatch = [regex]::Match($tspLocationContent, "directory:\s*(.+)")
        
        if (-not $directoryMatch.Success) {
            Write-Log "ERROR: Could not parse directory from tsp-location.yaml" -Level Error -Service $ServiceName
            return $false
        }
        
        $directory = $directoryMatch.Groups[1].Value.Trim()
        $specDirectory = Join-Path $specRepoRoot $directory
        $tspConfigFile = Join-Path $specDirectory "tspconfig.yaml"
        
        Write-Log "Spec directory: $specDirectory" -Level Verbose -Service $ServiceName
        Write-Log "tspconfig.yaml path: $tspConfigFile" -Level Verbose -Service $ServiceName
        
        if (-not (Test-Path $tspConfigFile)) {
            Write-Log "ERROR: tspconfig.yaml not found at: $tspConfigFile" -Level Error -Service $ServiceName
            return $false
        }
        
        # Read current content
        $content = Get-Content $tspConfigFile -Raw
        
        # Check if @azure-typespec/http-client-csharp section already exists
        if ($content -match '@azure-typespec/http-client-csharp') {
            Write-Log "@azure-typespec/http-client-csharp section already exists in tspconfig.yaml" -Level Info -Service $ServiceName
            return $true
        }
        
        # Find the namespace from @azure-tools/typespec-csharp section
        $namespaceMatch = [regex]::Match($content, '@azure-tools/typespec-csharp[^:]*:.*?namespace:\s*([^\s\r\n]+)', [System.Text.RegularExpressions.RegexOptions]::Singleline)
        
        if (-not $namespaceMatch.Success) {
            Write-Log "ERROR: Could not find namespace in @azure-tools/typespec-csharp section" -Level Error -Service $ServiceName
            return $false
        }
        
        $namespace = $namespaceMatch.Groups[1].Value.Trim()
        Write-Log "Found namespace: $namespace" -Level Verbose -Service $ServiceName
        
        # Create the new section to add
        $newSection = @"
  "@azure-typespec/http-client-csharp":
    emitter-output-dir: "{output-dir}/{service-dir}/{namespace}"
    namespace: $namespace
    model-namespace: false
"@
        
        # Find where to insert the new section (after options: line)
        if ($content -match '(options:\s*\r?\n)') {
            # Insert after the options: line
            $insertPosition = $content.IndexOf($matches[1]) + $matches[1].Length
            $beforeInsert = $content.Substring(0, $insertPosition)
            $afterInsert = $content.Substring($insertPosition)
            
            $updatedContent = $beforeInsert + $newSection + "`n" + $afterInsert
            
            # Write back to file
            Set-Content -Path $tspConfigFile -Value $updatedContent -NoNewline
            Write-Log "Added @azure-typespec/http-client-csharp section to tspconfig.yaml with namespace: $namespace" -Level Info -Service $ServiceName
        } else {
            Write-Log "WARNING: Could not find 'options:' section in tspconfig.yaml to insert new emitter configuration" -Level Warning -Service $ServiceName
            return $false
        }
        
        return $true
    }
    catch {
        Write-Log "ERROR: Failed to update tspconfig.yaml - $($_.Exception.Message)" -Level Error -Service $ServiceName
        return $false
    }
}

function Step7-GenerateCode {
    param(
        [string]$ServicePath,
        [string]$ServiceName,
        [string]$SpecRepo
    )
    
    if (-not (Write-Step -StepNumber 7 -StepName "Generate code" -Service $ServiceName)) {
        return $true
    }
    
    try {
        # Get the service spec directory from tsp-location.yaml
        $tspLocationPath = Join-Path $ServicePath "tsp-location.yaml"
        if (-not (Test-Path $tspLocationPath)) {
            Write-Log "ERROR: tsp-location.yaml not found at: $tspLocationPath" -Level Error -Service $ServiceName
            return $false
        }
        
        # Parse tsp-location.yaml to get directory
        $tspLocationContent = Get-Content $tspLocationPath -Raw
        if ($tspLocationContent -match 'directory:\s*(.+?)(?:\r?\n|$)') {
            $serviceSpecDir = $matches[1].Trim()
            $fullServiceSpecDir = Join-Path $SpecRepo $serviceSpecDir
            Write-Log "Service spec directory: $fullServiceSpecDir" -Level Info -Service $ServiceName
        } else {
            Write-Log "ERROR: Could not parse directory from tsp-location.yaml" -Level Error -Service $ServiceName
            return $false
        }
        
        # Create reports directory for today and this service in script directory
        $today = Get-Date -Format "yyyy-MM-dd"
        $reportDir = Join-Path $PSScriptRoot "reports\$today\$ServiceName"
        if (-not (Test-Path $reportDir)) {
            New-Item -ItemType Directory -Path $reportDir -Force | Out-Null
            Write-Log "Created report directory: $reportDir" -Level Info -Service $ServiceName
        }
        $buildLogPath = Join-Path $reportDir "generate-code.log"
        
        # Change to service directory and run dotnet build
        Push-Location $ServicePath
        try {
            Write-Log "Running code generation in $ServicePath..." -Level Info -Service $ServiceName
            Write-Log "Command: dotnet build /t:GenerateCode --tl:off /p:LocalSpecRepo=`"$fullServiceSpecDir`"" -Level Info -Service $ServiceName
            Write-Log "Build log will be saved to: $buildLogPath" -Level Info -Service $ServiceName
            
            $result = & dotnet build /t:GenerateCode --tl:off /p:LocalSpecRepo="$fullServiceSpecDir" 2>&1
            
            # Save build log to file
            $buildLogContent = @"
=== Code Generation Build Log ===
Date: $(Get-Date -Format "yyyy-MM-dd HH:mm:ss")
Service: $ServiceName
Service Path: $ServicePath
Spec Directory: $fullServiceSpecDir
Command: dotnet build /t:GenerateCode --tl:off /p:LocalSpecRepo="$fullServiceSpecDir"
Exit Code: $LASTEXITCODE

=== Build Output ===
$($result | Out-String)
"@
            $buildLogContent | Set-Content -Path $buildLogPath -Encoding UTF8
            Write-Log "Build log saved to: $buildLogPath" -Level Info -Service $ServiceName
            
            if ($LASTEXITCODE -eq 0) {
                Write-Log "Code generation completed successfully" -Level Info -Service $ServiceName
                Write-Log "Generation output: $($result | Out-String)" -Level Verbose -Service $ServiceName
                return $true
            } else {
                Write-Log "ERROR: Code generation failed with exit code $LASTEXITCODE" -Level Error -Service $ServiceName
                Write-Log "Generation error: $($result | Out-String)" -Level Error -Service $ServiceName
                return $false
            }
        }
        finally {
            Pop-Location
        }
    }
    catch {
        Write-Log "ERROR: Failed to generate code - $($_.Exception.Message)" -Level Error -Service $ServiceName
        return $false
    }
}

function Step8-BuildCode {
    param(
        [string]$ServicePath,
        [string]$ServiceName
    )
    
    if (-not (Write-Step -StepNumber 8 -StepName "Build code" -Service $ServiceName)) {
        return $true
    }
    
    try {
        # Create reports directory for today and this service in script directory
        $today = Get-Date -Format "yyyy-MM-dd"
        $reportDir = Join-Path $PSScriptRoot "reports\$today\$ServiceName"
        if (-not (Test-Path $reportDir)) {
            New-Item -ItemType Directory -Path $reportDir -Force | Out-Null
            Write-Log "Created report directory: $reportDir" -Level Info -Service $ServiceName
        }
        $buildLogPath = Join-Path $reportDir "build.log"
        
        # Change to service directory and run dotnet build
        Push-Location $ServicePath
        try {
            Write-Log "Running dotnet build in $ServicePath..." -Level Info -Service $ServiceName
            Write-Log "Command: dotnet build" -Level Info -Service $ServiceName
            Write-Log "Build log will be saved to: $buildLogPath" -Level Info -Service $ServiceName
            
            $result = & dotnet build 2>&1
            
            # Save build log to file
            $buildLogContent = @"
=== Code Build Log ===
Date: $(Get-Date -Format "yyyy-MM-dd HH:mm:ss")
Service: $ServiceName
Service Path: $ServicePath
Command: dotnet build
Exit Code: $LASTEXITCODE

=== Build Output ===
$($result | Out-String)
"@
            $buildLogContent | Set-Content -Path $buildLogPath -Encoding UTF8
            Write-Log "Build log saved to: $buildLogPath" -Level Info -Service $ServiceName
            
            if ($LASTEXITCODE -eq 0) {
                Write-Log "Build completed successfully" -Level Info -Service $ServiceName
                Write-Log "Build output: $($result | Out-String)" -Level Verbose -Service $ServiceName
                return $true
            } else {
                Write-Log "ERROR: Build failed with exit code $LASTEXITCODE" -Level Error -Service $ServiceName
                Write-Log "Build error: $($result | Out-String)" -Level Error -Service $ServiceName
                return $false
            }
        }
        finally {
            Pop-Location
        }
    }
    catch {
        Write-Log "ERROR: Failed to build code - $($_.Exception.Message)" -Level Error -Service $ServiceName
        return $false
    }
}

function Step9-GenerateReport {
    param(
        [string]$ServicePath,
        [string]$ServiceName,
        [bool]$Success
    )
    
    if (-not (Write-Step -StepNumber 9 -StepName "Generate report" -Service $ServiceName)) {
        return $true
    }
    
    try {
        # TBD: Implement report generation logic
        Write-Log "TBD: Generate report logic needs to be implemented" -Level Warning -Service $ServiceName
        
        # Placeholder for actual implementation
        # This might involve:
        # - Creating a detailed report of changes
        # - Documenting any issues encountered
        # - Generating summary statistics
        return $true
    }
    catch {
        Write-Log "ERROR: Failed to generate report - $($_.Exception.Message)" -Level Error -Service $ServiceName
        return $false
    }
}

function Process-Service {
    param(
        [PSCustomObject]$ServiceInfo
    )
    
    $serviceName = $ServiceInfo.Service
    $library = $ServiceInfo.Library
    
    Write-Log "Starting processing of service: $serviceName ($library)" -Level Info -Service $serviceName
    
    # Store current directory to restore later
    $originalLocation = Get-Location
    
    try {
        # Step 1: Find and convert path
        $absolutePath = Step1-FindAndConvertPath -ServiceInfo $ServiceInfo
        if (-not $absolutePath) {
            throw "Failed to find or convert service path"
        }
        
        # Step 2: Navigate to service directory
        if (-not (Step2-NavigateToServiceDirectory -ServicePath $absolutePath -ServiceName $serviceName)) {
            throw "Failed to navigate to service directory"
        }
        
        # Step 3: Update tsp-location.yaml
        if (-not (Step3-UpdateTspLocation -ServicePath $absolutePath -ServiceName $serviceName)) {
            Write-Log "Failed to update tsp-location.yaml, continuing..." -Level Warning -Service $serviceName
        }
        
        # Step 4: Update .csproj file
        if (-not (Step4-UpdateCsProject -ServicePath $absolutePath -ServiceName $serviceName)) {
            Write-Log "Failed to update .csproj file, continuing..." -Level Warning -Service $serviceName
        }
        
        # Step 5: Checkout spec
        if (-not (Step5-CheckoutSpec -ServicePath $absolutePath -ServiceName $serviceName)) {
            Write-Log "Failed to checkout spec, continuing..." -Level Warning -Service $serviceName
        }
        
        # Step 6: Update tspconfig.yaml
        if (-not (Step6-UpdateTspConfig -ServicePath $absolutePath -ServiceName $serviceName)) {
            Write-Log "Failed to update tspconfig.yaml, continuing..." -Level Warning -Service $serviceName
        }
        
        # Step 7: Generate code
        if (-not (Step7-GenerateCode -ServicePath $absolutePath -ServiceName $serviceName -SpecRepo "D:\work\spec")) {
            Write-Log "Failed to generate code, continuing..." -Level Warning -Service $serviceName
        }
        
        # Step 8: Build code
        if (-not (Step8-BuildCode -ServicePath $absolutePath -ServiceName $serviceName)) {
            Write-Log "Failed to build code, continuing..." -Level Warning -Service $serviceName
        }
        
        # Step 9: Generate report
        Step9-GenerateReport -ServicePath $absolutePath -ServiceName $serviceName -Success $true
        
        $script:ProcessedServices += [PSCustomObject]@{
            Service = $serviceName
            Library = $library
            Path = $absolutePath
            Status = "Success"
            Timestamp = Get-Date
        }
        
        Write-Log "Successfully processed service: $serviceName" -Level Info -Service $serviceName
    }
    catch {
        $errorMessage = $_.Exception.Message
        Write-Log "Failed to process service: $serviceName - $errorMessage" -Level Error -Service $serviceName
        
        $script:FailedServices += [PSCustomObject]@{
            Service = $serviceName
            Library = $library
            Error = $errorMessage
            Timestamp = Get-Date
        }
        
        # Generate report for failed service
        try {
            Step9-GenerateReport -ServicePath $absolutePath -ServiceName $serviceName -Success $false
        }
        catch {
            Write-Log "Failed to generate report for failed service: $serviceName" -Level Error -Service $serviceName
        }
    }
    finally {
        # Restore original directory
        Set-Location -Path $originalLocation
    }
}
#endregion

#region Main Execution
#region Main Execution
function Main {
    Write-Log "Starting Old Generator Services Migration Pipeline" -Level Info
    Write-Log "Mode: $Mode" -Level Info
    Write-Log "Repository Root: $RepoRoot" -Level Info
    Write-Log "Services JSON File: $ServicesJsonFile" -Level Info
    Write-Log "Log Level: $LogLevel" -Level Info
    Write-Log "Log File: $script:LogFile" -Level Info
    
    if ($SkipSteps.Count -gt 0) {
        Write-Log "Skipping steps: $($SkipSteps -join ', ')" -Level Info
    }
    
    if ($ServiceFilter) {
        Write-Log "Service Filter: $ServiceFilter" -Level Info
    }
    
    # Step 0: Extract services (if needed)
    if ($Mode -in @('Extract', 'Both')) {
        Write-Log "=== EXTRACTION PHASE ===" -Level Info
        
        if (-not (Step0-ExtractServices)) {
            Write-Log "FATAL ERROR: Failed to extract services" -Level Error
            return 1
        }
        
        Write-Log "Extraction phase completed successfully" -Level Info
    }
    
    # Processing phase (if needed)
    if ($Mode -in @('Process', 'Both')) {
        Write-Log "=== PROCESSING PHASE ===" -Level Info
        
        # Check if services JSON file exists
        if (-not (Test-Path $ServicesJsonFile)) {
            Write-Log "ERROR: Services JSON file not found: $ServicesJsonFile" -Level Error
            Write-Log "       Run with -Mode Extract first or provide existing JSON file" -Level Error
            return 1
        }
        
        # Check if repository root exists
        if (-not (Test-Path $RepoRoot)) {
            Write-Log "ERROR: Repository root not found: $RepoRoot" -Level Error
            return 1
        }
        
        try {
            # Load services from JSON
            $servicesData = Get-Content -Path $ServicesJsonFile -Raw | ConvertFrom-Json
            $libraries = $servicesData.Libraries
            
            Write-Log "Loaded $($libraries.Count) libraries from JSON file" -Level Info
            
            # Apply service filter if specified
            if ($ServiceFilter) {
                $libraries = $libraries | Where-Object { $_.Service -like $ServiceFilter }
                Write-Log "Filtered to $($libraries.Count) libraries matching filter: $ServiceFilter" -Level Info
            }
            
            if ($libraries.Count -eq 0) {
                Write-Log "No libraries to process" -Level Warning
                return 0
            }
            
            # Group by service to get unique services
            $serviceGroups = $libraries | Group-Object -Property Service
            Write-Log "Processing $($serviceGroups.Count) unique services" -Level Info
            
            # Process each service group
            foreach ($serviceGroup in $serviceGroups) {
                $serviceName = $serviceGroup.Name
                $serviceLibraries = $serviceGroup.Group
                
                Write-Log "Processing service group: $serviceName with $($serviceLibraries.Count) libraries" -Level Info
                
                # Process each library in the service
                foreach ($library in $serviceLibraries) {
                    Process-Service -ServiceInfo $library
                }
            }
            
            # Generate final summary
            Write-Log "Processing completed" -Level Info
            Write-Log "Processed services: $($script:ProcessedServices.Count)" -Level Info
            Write-Log "Failed services: $($script:FailedServices.Count)" -Level Info
            
            if ($script:FailedServices.Count -gt 0) {
                Write-Log "Failed services:" -Level Warning
                foreach ($failed in $script:FailedServices) {
                    Write-Log "  - $($failed.Service) ($($failed.Library)): $($failed.Error)" -Level Warning
                }
            }
            
            # Export results
            $results = @{
                Summary = @{
                    TotalProcessed = $script:ProcessedServices.Count
                    TotalFailed = $script:FailedServices.Count
                    ProcessingDate = Get-Date
                    LogFile = $LogFile
                    Mode = $Mode
                    ServiceFilter = $ServiceFilter
                    SkippedSteps = $SkipSteps
                }
                ProcessedServices = $script:ProcessedServices
                FailedServices = $script:FailedServices
            }
            
            $resultsFile = "processing-results-$(Get-Date -Format 'yyyyMMdd-HHmmss').json"
            $results | ConvertTo-Json -Depth 3 | Set-Content -Path $resultsFile
            Write-Log "Results saved to: $resultsFile" -Level Info
            
        }
        catch {
            Write-Log "FATAL ERROR in processing phase: $($_.Exception.Message)" -Level Error
            return 1
        }
    }
    
    Write-Log "=== PIPELINE COMPLETED ===" -Level Info
    return 0
}

# Execute main function
$exitCode = Main
exit $exitCode
#endregion