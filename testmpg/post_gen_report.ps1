param(
    [Parameter(Position=0,Mandatory=$true)] [string]$ServiceReportDir,
    [Parameter(Position=1,Mandatory=$false)] [string]$ServiceName,
    [Parameter(Position=2,Mandatory=$false)] [string]$OutFile
)

if (-not (Test-Path $ServiceReportDir -PathType Container)) {
    Write-Error "Service report directory not found: $ServiceReportDir"
    exit 2
}

if (-not $OutFile) { $OutFile = Join-Path $ServiceReportDir 'summary.md' }

$generateLog = Join-Path $ServiceReportDir 'generate.log'
$buildLog = Join-Path $ServiceReportDir 'build.log'

$genContent = ''
$buildContent = ''
if (Test-Path $generateLog) { $genContent = Get-Content -Path $generateLog -Raw -ErrorAction SilentlyContinue }
if (Test-Path $buildLog) { $buildContent = Get-Content -Path $buildLog -Raw -ErrorAction SilentlyContinue }

# Extract fields
$emitter = ''
if ($genContent -match 'Found emitter package\s+([^\s]+)') { $emitter = $Matches[1] }
$requiredPrefix = '@azure-typespec/http-client-csharp-mgmt'
if (-not [string]::IsNullOrEmpty($emitter)) {
    if (-not ($emitter -like "$requiredPrefix*")) {
        throw "Emitter package '$emitter' does not start with required prefix '$requiredPrefix'"
    }
}
$genSucceeded = ($genContent -match 'generation complete') -or ($genContent -match 'Build succeeded\.')
$filesWritten = 0
if ($genContent) { $filesWritten = (Select-String -InputObject $genContent -Pattern '^\s*Writing\s+' -AllMatches | Measure-Object).Count }
$npmWarnings = 0
if ($genContent) { $npmWarnings = (Select-String -InputObject $genContent -Pattern 'npm warn' -AllMatches | Measure-Object).Count }
$diagnosticsReported = ($genContent -match 'Diagnostics were reported')
$verifySucceeded = ($buildContent -match 'Build succeeded\.')
$apiCompatErrors = 0
if ($buildContent) { $apiCompatErrors = (Select-String -InputObject $buildContent -Pattern 'ApiCompat failed|error :' -AllMatches | Measure-Object).Count }

# Compose desired concise markdown output only
$out = @()
$out += "# Generation summary"
$out += ""
if ($ServiceName) { $out += "**Service:** $ServiceName" } else { $out += "**Service report dir:** $ServiceReportDir" }
$out += "**Report directory:** $ServiceReportDir"
$out += ""
$out += "- Emitter package: $([string]::IsNullOrEmpty($emitter) ? 'None detected' : $emitter)"
$out += "- Generation succeeded: $([bool]$genSucceeded)"
# Rename label to 'Build succeeded'
$out += "- Build succeeded: $([bool]$verifySucceeded)"
# ApiCompat / verification errors line intentionally omitted per user request

$out | Out-File -FilePath $OutFile -Encoding utf8
Write-Host "Generated concise summary: $OutFile" -ForegroundColor Green
exit 0
