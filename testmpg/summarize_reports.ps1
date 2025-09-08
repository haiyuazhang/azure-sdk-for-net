param(
    [Parameter(Position=0, Mandatory=$false)]
    [string]$ReportsDir
)

if (-not $ReportsDir) {
    Write-Error "Usage: .\summarize_reports.ps1 <reports-directory>  (example: reports/2025-09-09)"
    exit 1
}

$reportsPath = Resolve-Path -Path $ReportsDir -ErrorAction SilentlyContinue
if (-not $reportsPath) {
    Write-Error "Reports directory not found: $ReportsDir"
    exit 1
}

$reportsPath = $reportsPath.Path
Write-Host "Scanning reports in: $reportsPath" -ForegroundColor Cyan

$rows = @()

Get-ChildItem -Path $reportsPath -Directory | ForEach-Object {
    $serviceDir = $_.FullName
    $serviceName = $_.Name

    # Prefer using per-service summary.md exclusively for status detection
    $summaryFile = Join-Path $serviceDir 'summary.md'
    $emitter = '-'
    $generation = 'Unknown'
    $build = 'Unknown'

    if (Test-Path $summaryFile) {
        $content = Get-Content -Path $summaryFile -Raw -ErrorAction SilentlyContinue
        # Emitter line formats vary; try common patterns
        if ($content -match 'Emitter package\s*[:\-]\s*(.+)') { $emitter = $Matches[1].Trim() }
        elseif ($content -match 'Emitter\s*[:\-]\s*(.+)') { $emitter = $Matches[1].Trim() }

        # Robustly detect Generation status: support forms like
        #   Generation succeeded: False
        #   Generation: True
        #   Generation succeeded
        if ($content -match '(?mi)Generation\s*(?:succeeded|failed)?\s*[:\-]?\s*(True|False|true|false|Succeeded|Failed|succeeded|failed)') {
            $val = $Matches[1].ToString().ToLower()
            if ($val -in @('true','succeeded')) { $generation = 'Succeeded' } else { $generation = 'Failed' }
        }
        elseif ($content -match '(?i)Generation\s*(succeeded|failed)') {
            $generation = ($Matches[1].ToLower() -eq 'succeeded') ? 'Succeeded' : 'Failed'
        }

        # Robustly detect Build status similarly
        if ($content -match '(?mi)Build\s*(?:succeeded|failed)?\s*[:\-]?\s*(True|False|true|false|Succeeded|Failed|succeeded|failed)') {
            $valb = $Matches[1].ToString().ToLower()
            if ($valb -in @('true','succeeded')) { $build = 'Succeeded' } else { $build = 'Failed' }
        }
        elseif ($content -match '(?i)Build\s*(succeeded|failed)') {
            $build = ($Matches[1].ToLower() -eq 'succeeded') ? 'Succeeded' : 'Failed'
        }
        
        # If generation failed or there is no generation log, force build to Failed
        $generateLogFile = Join-Path $serviceDir 'generate.log'
        if (($generation -eq 'Failed') -or -not (Test-Path $generateLogFile)) {
            $build = 'Failed'
        }
    }

    $rows += [PSCustomObject]@{
        Service = $serviceName
        Emitter = $emitter
        Generation = $generation
        Build = $build
        ReportDir = $serviceDir
    }
}

if ($rows.Count -eq 0) {
    Write-Host "No service reports found under $reportsPath" -ForegroundColor Yellow
    exit 0
}

## Compute overall statistics
$total = $rows.Count
$genSuccess = ($rows | Where-Object { $_.Generation -eq 'Succeeded' }).Count
$genFail = ($rows | Where-Object { $_.Generation -ne 'Succeeded' }).Count
$buildSuccess = ($rows | Where-Object { $_.Build -eq 'Succeeded' }).Count
$buildFail = ($rows | Where-Object { $_.Build -ne 'Succeeded' }).Count

function Format-Pct([int]$num, [int]$den) {
    if ($den -eq 0) { return "0%" }
    $pct = [math]::Round(($num * 100.0) / $den, 1)
    return "${pct}%"
}

$overallLines = @()
$overallLines += "### Overall Statistics"
$overallLines += ""
$overallLines += "| Metric | Count | Percentage |"
$overallLines += "|--------|-------|------------|"
$overallLines += "| **Total SDKs Analyzed** | $total | 100% |"
$overallLines += "| **Successful Builds** | $buildSuccess | $(Format-Pct $buildSuccess $total) |"
$overallLines += "| **Failed/Partial Builds** | $buildFail | $(Format-Pct $buildFail $total) |"
$overallLines += "| **Code Generation Successes** | $genSuccess | $(Format-Pct $genSuccess $total) |"
$overallLines += "| **Code Generation Failures** | $genFail | $(Format-Pct $genFail $total) |"
$overallLines += ""

## Add list of services where code generation failed
$genFailedRows = $rows | Where-Object { $_.Generation -ne 'Succeeded' } | Sort-Object Service
    if ($genFailedRows.Count -gt 0) {
    $overallLines += "### Code Generation Failed services"
    $overallLines += ""
    foreach ($f in $genFailedRows) {
        # Only list the service name as requested
        $line = "- $($f.Service)"
        $overallLines += $line
    }
    $overallLines += ""
}

## Add list of services where both generation and build succeeded
$genBuildSuccessRows = $rows | Where-Object { $_.Generation -eq 'Succeeded' -and $_.Build -eq 'Succeeded' } | Sort-Object Service
if ($genBuildSuccessRows.Count -gt 0) {
    $overallLines += "### Services with successful generation and build"
    $overallLines += ""
    foreach ($s in $genBuildSuccessRows) {
        $overallLines += "- $($s.Service)"
    }
    $overallLines += ""
}


# Only write the Overall Statistics block as requested
$dirName = Split-Path -Path $ReportsDir -Leaf
$outFileName = "summary_$dirName.md"
$outFile = Join-Path $ReportsDir $outFileName

$overallLines -join "`n" | Out-File -FilePath $outFile -Encoding utf8

Write-Host "Wrote overall statistics: $outFile" -ForegroundColor Green
Write-Host "" -ForegroundColor Cyan
Write-Host ($overallLines -join "`n")

exit 0
