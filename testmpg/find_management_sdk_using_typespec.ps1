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
    $generatedPath = Join-Path $dir.FullName "src/generated"

    if (Test-Path $tspFile -PathType Leaf) {
        Write-Output "   ✅ Found tsp-location.yaml"

        if (Test-Path $generatedPath) {
            Write-Output "   📂 Found src/generated"
            $resourceFiles = Get-ChildItem -Path $generatedPath -Filter "*Resource.cs" -File -Recurse -ErrorAction SilentlyContinue
            if ($resourceFiles.Count -gt 0) {
                Write-Output "   ✅ Found at least one *Resource.cs"
                $absolutePath = $dir.FullName
                $absolutePath | Out-File -FilePath $outputFile -Append
            }
            else {
                Write-Output "   ⚠️ No *Resource.cs found"
            }
        }
        else {
            Write-Output "   ❌ No src/generated directory"
        }
    }
    else {
        Write-Output "   ❌ No tsp-location.yaml"
    }
}

Write-Output "Done. Results saved in $outputFile"
