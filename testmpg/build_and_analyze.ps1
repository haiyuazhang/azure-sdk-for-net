# PowerShell script to build all TypeSpec SDKs and analyze issues
param(
    [string]$SdkListFile = "d:\work\azure-sdk-for-net\testmpg\tspsdk",
    [string]$ReportsDir = "d:\work\azure-sdk-for-net\testmpg\reports"
)

# Read the SDK paths
$sdkPaths = Get-Content $SdkListFile

# Create summary report
$summaryReport = @"
# TypeSpec SDK Build Analysis Report
Generated on: $(Get-Date)
Total SDKs analyzed: $($sdkPaths.Count)

## Summary

"@

$successCount = 0
$failureCount = 0
$detailedResults = @()

foreach ($sdkPath in $sdkPaths) {
    $sdkPath = $sdkPath.Trim()
    if ([string]::IsNullOrEmpty($sdkPath)) { continue }
    
    Write-Host "Processing: $sdkPath" -ForegroundColor Yellow
    
    # Extract SDK name from path
    $sdkName = Split-Path $sdkPath -Leaf
    $reportFile = Join-Path $ReportsDir "$sdkName-build-report.md"
    
    # Start building report for this SDK
    $sdkReport = @"
# Build Report for $sdkName
SDK Path: $sdkPath
Generated on: $(Get-Date)

## Code Generation Phase

"@
    
    try {
        # Change to SDK directory
        Set-Location $sdkPath
        
        # Check if gencmd exists
        if (-Not (Test-Path "gencmd")) {
            $sdkReport += "❌ **ERROR**: gencmd file not found`n`n"
            $detailedResults += [PSCustomObject]@{
                SDK = $sdkName
                Status = "FAILED"
                Issue = "gencmd file not found"
                CodeGen = "FAILED"
                Build = "SKIPPED"
            }
            $failureCount++
            $sdkReport | Out-File $reportFile -Encoding UTF8
            continue
        }
        
        # Read and execute gencmd
        $genCommand = Get-Content "gencmd" | Where-Object { $_.Trim() -ne "" } | Select-Object -First 1
        $sdkReport += "**Command**: ``$genCommand```n`n"
        
        Write-Host "  Running code generation..." -ForegroundColor Cyan
        $genResult = Invoke-Expression $genCommand 2>&1
        $genExitCode = $LASTEXITCODE
        
        if ($genExitCode -eq 0) {
            $sdkReport += "✅ **Code generation completed successfully**`n`n"
            $codeGenStatus = "SUCCESS"
        } else {
            $sdkReport += "❌ **Code generation failed**`n`n"
            $sdkReport += "**Error Output:**`n``````n$genResult`n```````n`n"
            $codeGenStatus = "FAILED"
        }
        
        $sdkReport += "## Build Phase`n`n"
        
        # Run dotnet build
        Write-Host "  Running dotnet build..." -ForegroundColor Cyan
        $buildResult = dotnet build 2>&1
        $buildExitCode = $LASTEXITCODE
        
        if ($buildExitCode -eq 0) {
            $sdkReport += "✅ **Build completed successfully**`n`n"
            $buildStatus = "SUCCESS"
            $overallStatus = if ($codeGenStatus -eq "SUCCESS") { "SUCCESS" } else { "PARTIAL" }
            $successCount++
        } else {
            $sdkReport += "❌ **Build failed**`n`n"
            $sdkReport += "**Build Output:**`n``````n$buildResult`n```````n`n"
            $buildStatus = "FAILED"
            $overallStatus = "FAILED"
            $failureCount++
            
            # Try to extract specific error information
            $errorLines = $buildResult | Where-Object { $_ -match "error" -or $_ -match "Error" }
            if ($errorLines) {
                $sdkReport += "## Key Errors`n`n"
                foreach ($errorLine in $errorLines | Select-Object -First 10) {
                    $sdkReport += "- $errorLine`n"
                }
                $sdkReport += "`n"
            }
        }
        
        $detailedResults += [PSCustomObject]@{
            SDK = $sdkName
            Status = $overallStatus
            Issue = if ($overallStatus -eq "SUCCESS") { "None" } else { "Build/CodeGen issues" }
            CodeGen = $codeGenStatus
            Build = $buildStatus
        }
        
    } catch {
        $sdkReport += "❌ **Unexpected error**: $($_.Exception.Message)`n`n"
        $detailedResults += [PSCustomObject]@{
            SDK = $sdkName
            Status = "ERROR"
            Issue = $_.Exception.Message
            CodeGen = "ERROR"
            Build = "ERROR"
        }
        $failureCount++
    }
    
    # Save individual SDK report
    $sdkReport | Out-File $reportFile -Encoding UTF8
    Write-Host "  Report saved: $reportFile" -ForegroundColor Green
}

# Generate summary report
$summaryReport += @"
- ✅ Successful builds: $successCount
- ❌ Failed builds: $failureCount

## Detailed Results

| SDK | Overall Status | Code Generation | Build | Primary Issue |
|-----|----------------|-----------------|-------|---------------|
"@

foreach ($result in $detailedResults) {
    $statusIcon = switch ($result.Status) {
        "SUCCESS" { "✅" }
        "PARTIAL" { "⚠️" }
        "FAILED" { "❌" }
        "ERROR" { "💥" }
    }
    $summaryReport += "`n| $($result.SDK) | $statusIcon $($result.Status) | $($result.CodeGen) | $($result.Build) | $($result.Issue) |"
}

$summaryReport += @"

## Failed SDKs

"@

$failedSdks = $detailedResults | Where-Object { $_.Status -ne "SUCCESS" }
foreach ($failed in $failedSdks) {
    $summaryReport += "- **$($failed.SDK)**: $($failed.Issue)`n"
}

$summaryReport += @"

## Next Steps

1. Review individual SDK reports in the reports directory
2. Address code generation issues first, then build issues
3. Check for common patterns in failures
4. Update TypeSpec specifications or build configurations as needed

---
*Report generated by build_and_analyze.ps1*
"@

# Save summary report
$summaryReportFile = Join-Path $ReportsDir "build-summary-report.md"
$summaryReport | Out-File $summaryReportFile -Encoding UTF8

Write-Host "`n🎉 Analysis complete!" -ForegroundColor Green
Write-Host "Summary report: $summaryReportFile" -ForegroundColor Green
Write-Host "Individual reports in: $ReportsDir" -ForegroundColor Green
Write-Host "Success rate: $successCount/$($sdkPaths.Count) ($([math]::Round(($successCount / $sdkPaths.Count) * 100, 1))%)" -ForegroundColor Green
