#!/usr/bin/env pwsh

<#
.SYNOPSIS
    Extracts services from the "Data Plane Libraries using TypeSpec (Old Generator)" section of Library_Inventory.md

.DESCRIPTION
    This script parses the Library_Inventory.md file and extracts all services mentioned in the 
    "Data Plane Libraries using TypeSpec (Old Generator)" section. It outputs the services as 
    a list and optionally saves them to a file.

.PARAMETER InputFile
    Path to the Library_Inventory.md file. Defaults to the standard location in the repository.

.PARAMETER OutputFile
    Optional path to save the extracted services list. If not specified, output is written to console only.

.PARAMETER Format
    Output format: 'List', 'CSV', or 'JSON'. Defaults to 'List'.

.EXAMPLE
    .\Extract-OldGeneratorServices.ps1
    
.EXAMPLE
    .\Extract-OldGeneratorServices.ps1 -OutputFile "old-generator-services.txt"
    
.EXAMPLE
    .\Extract-OldGeneratorServices.ps1 -Format CSV -OutputFile "old-generator-services.csv"

.EXAMPLE
    .\Extract-OldGeneratorServices.ps1 -Format JSON -OutputFile "old-generator-services.json"
#>

param(
    [Parameter()]
    [string]$InputFile = "$PSScriptRoot\..\doc\GeneratorMigration\Library_Inventory.md",
    
    [Parameter()]
    [string]$OutputFile,
    
    [Parameter()]
    [ValidateSet('List', 'CSV', 'JSON')]
    [string]$Format = 'List'
)

# Function to extract services from the markdown content
function Extract-OldGeneratorServices {
    param([string[]]$Content)
    
    $services = @()
    $inOldGeneratorSection = $false
    $inTable = $false
    
    foreach ($line in $Content) {
        # Check if we've reached the "Data Plane Libraries using TypeSpec (Old Generator)" section
        if ($line -match "^## Data Plane Libraries using TypeSpec \(Old Generator\)") {
            $inOldGeneratorSection = $true
            Write-Verbose "Found Old Generator section"
            continue
        }
        
        # Check if we've reached the next section (exit the old generator section)
        if ($inOldGeneratorSection -and $line -match "^## ") {
            Write-Verbose "Exiting Old Generator section"
            break
        }
        
        # Check if we're in the table header
        if ($inOldGeneratorSection -and $line -match "^\| Service \| Library \| Path \|") {
            $inTable = $true
            Write-Verbose "Found table header"
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
            Write-Verbose "Found service: $service"
        }
    }
    
    return $services
}

# Main execution
try {
    # Check if input file exists
    if (-not (Test-Path $InputFile)) {
        throw "Input file not found: $InputFile"
    }
    
    Write-Host "Reading Library_Inventory.md from: $InputFile" -ForegroundColor Green
    
    # Read the content
    $content = Get-Content -Path $InputFile -Encoding UTF8
    
    # Extract services
    $services = Extract-OldGeneratorServices -Content $content
    
    if ($services.Count -eq 0) {
        Write-Warning "No services found in the Old Generator section"
        return
    }
    
    Write-Host "Found $($services.Count) services using TypeSpec (Old Generator)" -ForegroundColor Green
    
    # Output based on format
    switch ($Format) {
        'List' {
            $output = @()
            $output += "Data Plane Libraries using TypeSpec (Old Generator)"
            $output += "=" * 50
            $output += ""
            
            foreach ($service in $services) {
                $output += "Service: $($service.Service)"
                $output += "Library: $($service.Library)"
                $output += "Path: $($service.Path)"
                $output += ""
            }
            
            # Also create a simple list of unique service names
            $uniqueServices = $services.Service | Sort-Object -Unique
            $output += "Unique Services ($($uniqueServices.Count)):"
            $output += "-" * 20
            $uniqueServices | ForEach-Object { $output += $_ }
        }
        
        'CSV' {
            $output = $services | ConvertTo-Csv -NoTypeInformation
        }
        
        'JSON' {
            $result = @{
                TotalCount = $services.Count
                UniqueServices = ($services.Service | Sort-Object -Unique)
                Libraries = $services
            }
            $output = $result | ConvertTo-Json -Depth 3
        }
    }
    
    # Display output
    if ($Format -eq 'JSON') {
        Write-Host $output
    } else {
        $output | ForEach-Object { Write-Host $_ }
    }
    
    # Save to file if specified
    if ($OutputFile) {
        $output | Out-File -FilePath $OutputFile -Encoding UTF8
        Write-Host "`nOutput saved to: $OutputFile" -ForegroundColor Green
    }
    
    # Summary
    $uniqueServiceCount = ($services.Service | Sort-Object -Unique).Count
    Write-Host "`nSummary:" -ForegroundColor Yellow
    Write-Host "  Total libraries: $($services.Count)" -ForegroundColor White
    Write-Host "  Unique services: $uniqueServiceCount" -ForegroundColor White
    
    if ($uniqueServiceCount -gt 0) {
        Write-Host "`nUnique service names:" -ForegroundColor Yellow
        $services.Service | Sort-Object -Unique | ForEach-Object { 
            Write-Host "  - $_" -ForegroundColor Cyan 
        }
    }
}
catch {
    Write-Error "Error: $($_.Exception.Message)"
    exit 1
}