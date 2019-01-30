# RiskSense requires TLS 1.2
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

# Set the base URI
$uri = 'https://platform.risksense.com/api/v1'

# Get public and private function definition files.
$functions  = Get-ChildItem -Path $PSScriptRoot\*\*.ps1 -ErrorAction SilentlyContinue

# Dot source the files
$functions.ForEach{
    try {. $_.FullName}
    catch {Write-Error -Message "Failed to import function $($_.FullName)"}
}
