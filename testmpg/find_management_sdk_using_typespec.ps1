$basePath = "D:\work\azure-sdk-for-net\sdk"


$today = Get-Date -Format "yyyy-MM-dd"
$outputFile = "management_sdks_using_typespec-$today.txt"

# If the output file already exists, remove it so we start fresh
if (Test-Path $outputFile) {
    Remove-Item $outputFile -Force
}


# Only look two levels deep: sdk/*/*
$targetDirs = Get-ChildItem -Path $basePath -Directory | ForEach-Object {
    Get-ChildItem -Path $_.FullName -Directory
}

foreach ($dir in $targetDirs) {
    Write-Output "🔍 Checking: $($dir.FullName)"

    $tspFile = Join-Path $dir.FullName "tsp-location.yaml"

    if (Test-Path $tspFile -PathType Leaf) {
        Write-Output "   ✅ Found tsp-location.yaml"

        if ($dir.FullName -like "*Azure.ResourceManager*") {
            Write-Output "   ✅ Directory path contains Azure.ResourceManager"
            $absolutePath = $dir.FullName
            $absolutePath | Out-File -FilePath $outputFile -Append
        }
        else {
            Write-Output "   ⚠️ Directory path does not contain Azure.ResourceManager"
        }
    }
    else {
        Write-Output "   ❌ No tsp-location.yaml"
    }
}

Write-Output "Done. Results saved in $outputFile"
