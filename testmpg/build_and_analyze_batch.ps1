# PowerShell script to build TypeSpec SDKs in batches with better error handling
param(
    [string]$SdkListFile = "d:\work\azure-sdk-for-net\testmpg\tspsdk",
    [string]$ReportsDir = "d:\work\azure-sdk-for-net\testmpg\reports",
    [int]$StartIndex = 0,
    [int]$BatchSize = 5,
    [switch]$ContinueOnError
)

# Set default for ContinueOnError
if (-not $PSBoundParameters.ContainsKey('ContinueOnError')) {
    $ContinueOnError = $true
}

# Function to analyze build output and extract key information
function Get-BuildAnalysis {
    param(
        [string]$Output,
        [int]$ExitCode
    )
    
    $analysis = @{
        Success = $ExitCode -eq 0
        Errors = @()
        Warnings = @()
        SuccessfulProjects = @()
        FailedProjects = @()
    }
    
    $lines = $Output -split "`n"
    
    foreach ($line in $lines) {
        $line = $line.Trim()
        
        # Extract successful builds
        if ($line -match "(.+?)\s+(net\d+\.\d+|netstandard\d+\.\d+|net\d+)\s+succeeded") {
            $analysis.SuccessfulProjects += $matches[1].Trim()
        }
        
        # Extract failed builds
        if ($line -match "(.+?)\s+(net\d+\.\d+|netstandard\d+\.\d+|net\d+)\s+failed") {
            $analysis.FailedProjects += $matches[1].Trim()
        }
        
        # Extract errors
        if ($line -match "error\s+(CS\d+|MSB\d+):" -or $line -match ":\s*error\s+" -or $line -match "Build FAILED") {
            $analysis.Errors += $line
        }
        
        # Extract warnings
        if ($line -match "warning\s+(CS\d+|MSB\d+):" -or $line -match ":\s*warning\s+") {
            $analysis.Warnings += $line
        }
    }
    
    return $analysis
}

# Read SDK paths
$allSdkPaths = Get-Content $SdkListFile | Where-Object { $_.Trim() -ne "" }
$totalSdks = $allSdkPaths.Count

Write-Host "=== TypeSpec SDK Build Analysis Script ===" -ForegroundColor Cyan
Write-Host "Total SDKs to process: $totalSdks" -ForegroundColor Green
Write-Host "Starting from index: $StartIndex" -ForegroundColor Green
Write-Host "Batch size: $BatchSize" -ForegroundColor Green
Write-Host "Reports directory: $ReportsDir" -ForegroundColor Green
Write-Host ""

# Calculate batch range
$endIndex = [Math]::Min($StartIndex + $BatchSize - 1, $totalSdks - 1)
$batchSdks = $allSdkPaths[$StartIndex..$endIndex]

Write-Host "Processing batch: SDKs $($StartIndex + 1) to $($endIndex + 1)" -ForegroundColor Yellow
Write-Host ""

$batchResults = @()
$currentSdk = 0

foreach ($sdkPath in $batchSdks) {
    $currentSdk++
    $globalIndex = $StartIndex + $currentSdk
    
    $sdkPath = $sdkPath.Trim()
    $sdkName = Split-Path $sdkPath -Leaf
    
    Write-Host "[$currentSdk/$BatchSize] Processing: $sdkName" -ForegroundColor Cyan
    Write-Host "  Path: $sdkPath" -ForegroundColor Gray
    
    $reportFile = Join-Path $ReportsDir "$sdkName-build-report.md"
    $startTime = Get-Date
    
    # Initialize SDK report
    $sdkReport = @"
# Build Report for $sdkName
SDK Path: $sdkPath
Generated on: $(Get-Date)
Global Index: $globalIndex of $totalSdks

## Code Generation Phase

"@

    $result = @{
        SDK = $sdkName
        Path = $sdkPath
        Status = "UNKNOWN"
        CodeGenStatus = "NOT_STARTED"
        BuildStatus = "NOT_STARTED"
        Issues = @()
        ProcessingTime = $null
    }

    try {
        # Validate SDK path exists
        if (-Not (Test-Path $sdkPath)) {
            throw "SDK path does not exist: $sdkPath"
        }
        
        # Change to SDK directory
        Set-Location $sdkPath -ErrorAction Stop
        
        # Check for gencmd
        if (-Not (Test-Path "gencmd")) {
            throw "gencmd file not found in SDK directory"
        }
        
        # Read gencmd
        $genCommand = (Get-Content "gencmd" | Where-Object { $_.Trim() -ne "" } | Select-Object -First 1).Trim()
        $sdkReport += "**Command**: ``$genCommand```n`n"
        
        Write-Host "    Running code generation..." -ForegroundColor Blue
        
        # Execute code generation with timeout protection
        $genJob = Start-Job -ScriptBlock {
            param($cmd, $workDir)
            Set-Location $workDir
            $output = Invoke-Expression $cmd 2>&1
            return @{
                Output = $output -join "`n"
                ExitCode = $LASTEXITCODE
            }
        } -ArgumentList $genCommand, $sdkPath
        
        # Wait for code generation (max 5 minutes)
        $genCompleted = Wait-Job $genJob -Timeout 300
        
        if ($genCompleted) {
            $genResult = Receive-Job $genJob
            $genExitCode = $genResult.ExitCode
            $genOutput = $genResult.Output
            Remove-Job $genJob
        } else {
            Stop-Job $genJob
            Remove-Job $genJob
            throw "Code generation timed out after 5 minutes"
        }
        
        if ($genExitCode -eq 0) {
            $sdkReport += "✅ **Code generation completed successfully**`n`n"
            $result.CodeGenStatus = "SUCCESS"
            Write-Host "    ✅ Code generation successful" -ForegroundColor Green
        } else {
            $sdkReport += "❌ **Code generation failed**`n`n"
            $sdkReport += "**Error Output:**`n``````text`n$genOutput`n```````n`n"
            $result.CodeGenStatus = "FAILED"
            $result.Issues += "Code generation failed"
            Write-Host "    ❌ Code generation failed" -ForegroundColor Red
        }
        
        $sdkReport += "## Build Phase`n`n"
        
        # Run dotnet build
        Write-Host "    Running dotnet build..." -ForegroundColor Blue
        
        $buildJob = Start-Job -ScriptBlock {
            param($workDir)
            Set-Location $workDir
            $output = dotnet build 2>&1
            return @{
                Output = $output -join "`n"
                ExitCode = $LASTEXITCODE
            }
        } -ArgumentList $sdkPath
        
        # Wait for build (max 3 minutes)
        $buildCompleted = Wait-Job $buildJob -Timeout 180
        
        if ($buildCompleted) {
            $buildResult = Receive-Job $buildJob
            $buildExitCode = $buildResult.ExitCode
            $buildOutput = $buildResult.Output
            Remove-Job $buildJob
        } else {
            Stop-Job $buildJob
            Remove-Job $buildJob
            throw "Build timed out after 3 minutes"
        }
        
        # Analyze build results
        $buildAnalysis = Get-BuildAnalysis -Output $buildOutput -ExitCode $buildExitCode
        
        if ($buildAnalysis.Success) {
            $sdkReport += "✅ **Build completed successfully**`n`n"
            $result.BuildStatus = "SUCCESS"
            $result.Status = if ($result.CodeGenStatus -eq "SUCCESS") { "SUCCESS" } else { "PARTIAL" }
            Write-Host "    ✅ Build successful" -ForegroundColor Green
        } else {
            $sdkReport += "❌ **Build failed**`n`n"
            $result.BuildStatus = "FAILED"
            $result.Status = "FAILED"
            Write-Host "    ❌ Build failed" -ForegroundColor Red
            
            # Add build analysis
            if ($buildAnalysis.SuccessfulProjects.Count -gt 0) {
                $sdkReport += "### Successful Projects`n"
                foreach ($proj in $buildAnalysis.SuccessfulProjects | Sort-Object | Get-Unique) {
                    $sdkReport += "- ✅ $proj`n"
                }
                $sdkReport += "`n"
            }
            
            if ($buildAnalysis.FailedProjects.Count -gt 0) {
                $sdkReport += "### Failed Projects`n"
                foreach ($proj in $buildAnalysis.FailedProjects | Sort-Object | Get-Unique) {
                    $sdkReport += "- ❌ $proj`n"
                    $result.Issues += "Failed project: $proj"
                }
                $sdkReport += "`n"
            }
            
            if ($buildAnalysis.Errors.Count -gt 0) {
                $sdkReport += "### Key Errors`n"
                $uniqueErrors = $buildAnalysis.Errors | Sort-Object | Get-Unique | Select-Object -First 15
                foreach ($errorLine in $uniqueErrors) {
                    $cleanError = $errorLine -replace '^\s*', '' -replace '\s+', ' '
                    $sdkReport += "- $cleanError`n"
                    if ($result.Issues.Count -lt 5) {
                        $result.Issues += $cleanError
                    }
                }
                $sdkReport += "`n"
            }
        }
        
        # Add full build output for reference
        $sdkReport += "## Full Build Output`n`n"
        $sdkReport += "``````text`n$buildOutput`n```````n`n"
        
    } catch {
        $errorMessage = $_.Exception.Message
        $sdkReport += "❌ **Unexpected error**: $errorMessage`n`n"
        $result.Status = "ERROR"
        $result.Issues += $errorMessage
        Write-Host "    💥 Error: $errorMessage" -ForegroundColor Red
        
        if (-not $ContinueOnError) {
            throw
        }
    }
    
    $endTime = Get-Date
    $processingTime = $endTime - $startTime
    $result.ProcessingTime = $processingTime.ToString("mm\:ss")
    
    $sdkReport += "---`n*Processing time: $($result.ProcessingTime)*`n"
    
    # Save individual report
    $sdkReport | Out-File $reportFile -Encoding UTF8
    $batchResults += $result
    
    Write-Host "  📄 Report saved: $reportFile" -ForegroundColor Green
    Write-Host "  ⏱️  Processing time: $($result.ProcessingTime)" -ForegroundColor Gray
    Write-Host ""
}

# Generate batch summary
$batchSummary = @"
# Batch Summary Report
Batch Range: SDKs $($StartIndex + 1) to $($endIndex + 1) of $totalSdks
Generated on: $(Get-Date)

## Batch Results

| # | SDK | Status | Code Gen | Build | Time | Primary Issues |
|---|-----|---------|----------|-------|------|----------------|
"@

foreach ($result in $batchResults) {
    $statusIcon = switch ($result.Status) {
        "SUCCESS" { "✅" }
        "PARTIAL" { "⚠️" }
        "FAILED" { "❌" }
        "ERROR" { "💥" }
        default { "❓" }
    }
    
    $primaryIssue = if ($result.Issues.Count -gt 0) { $result.Issues[0] } else { "None" }
    if ($primaryIssue.Length -gt 50) { $primaryIssue = $primaryIssue.Substring(0, 50) + "..." }
    
    $globalIdx = $StartIndex + [Array]::IndexOf($batchResults, $result) + 1
    $batchSummary += "`n| $globalIdx | $($result.SDK) | $statusIcon $($result.Status) | $($result.CodeGenStatus) | $($result.BuildStatus) | $($result.ProcessingTime) | $primaryIssue |"
}

$successCount = ($batchResults | Where-Object { $_.Status -eq "SUCCESS" }).Count
$failedCount = $batchResults.Count - $successCount

$batchSummary += @"

## Summary
- ✅ Successful: $successCount
- ❌ Failed/Error: $failedCount
- 📊 Success Rate: $([math]::Round(($successCount / $batchResults.Count) * 100, 1))%

## Next Steps
- Review individual reports for detailed error analysis
- Run next batch: ``.\build_and_analyze_batch.ps1 -StartIndex $($endIndex + 1)``
- For debugging specific SDK: Navigate to SDK path and run commands manually

---
*Generated by build_and_analyze_batch.ps1*
"@

# Save batch summary
$batchSummaryFile = Join-Path $ReportsDir "batch-summary-$($StartIndex+1)-to-$($endIndex+1).md"
$batchSummary | Out-File $batchSummaryFile -Encoding UTF8

Write-Host "🎉 Batch processing complete!" -ForegroundColor Green
Write-Host "📊 Success rate: $successCount/$($batchResults.Count) ($([math]::Round(($successCount / $batchResults.Count) * 100, 1))%)" -ForegroundColor Green
Write-Host "📄 Batch summary: $batchSummaryFile" -ForegroundColor Green

if ($endIndex -lt ($totalSdks - 1)) {
    Write-Host "🚀 To process next batch, run:" -ForegroundColor Yellow
    Write-Host "   .\build_and_analyze_batch.ps1 -StartIndex $($endIndex + 1)" -ForegroundColor Cyan
}
