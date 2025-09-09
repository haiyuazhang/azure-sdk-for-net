$today = Get-Date -Format "yyyy-MM-dd"
$managementSdksFile = "management_sdks_using_typespec-$today.txt"
$reportsDir = "reports\$today"

# Check if the management SDKs file exists
if (-not (Test-Path $managementSdksFile)) {
    Write-Error "Management SDKs file not found: $managementSdksFile"
    exit 1
}

# Check if the reports directory exists
if (-not (Test-Path $reportsDir)) {
    Write-Error "Reports directory not found: $reportsDir"
    exit 1
}

Write-Output "🧹 Cleaning up reports directory: $reportsDir"
Write-Output "📋 Using management SDKs list: $managementSdksFile"

# Read the management SDKs and extract service names
$managementSdks = Get-Content $managementSdksFile
$validServices = @()

foreach ($sdkPath in $managementSdks) {
    # Extract service name from path like "D:\work\azure-sdk-for-net\sdk\servicename\Azure.ResourceManager.ServiceName"
    if ($sdkPath -match "\\sdk\\([^\\]+)\\") {
        $serviceName = $matches[1]
        $validServices += $serviceName
        Write-Output "   ✅ Valid service: $serviceName"
    }
}

Write-Output ""
Write-Output "📁 Found $($validServices.Count) valid services in management SDKs list"
Write-Output ""

# Get all directories in the reports folder (excluding files)
$reportDirs = Get-ChildItem -Path $reportsDir -Directory

$deletedCount = 0
$keptCount = 0

foreach ($reportDir in $reportDirs) {
    $serviceName = $reportDir.Name
    
    if ($serviceName -in $validServices) {
        Write-Output "   ✅ Keeping: $serviceName (found in management SDKs)"
        $keptCount++
    } else {
        Write-Output "   🗑️ Deleting: $serviceName (not in management SDKs)"
        try {
            Remove-Item -Path $reportDir.FullName -Recurse -Force
            $deletedCount++
            Write-Output "      ✅ Successfully deleted: $serviceName"
        } catch {
            Write-Error "      ❌ Failed to delete $serviceName`: $_"
        }
    }
}

Write-Output ""
Write-Output "📊 Summary:"
Write-Output "   - Kept: $keptCount directories"
Write-Output "   - Deleted: $deletedCount directories"
Write-Output "   - Total processed: $($reportDirs.Count) directories"
Write-Output ""
Write-Output "✅ Cleanup completed!"
