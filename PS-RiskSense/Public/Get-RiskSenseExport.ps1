function Get-RiskSenseExport {
    <#
    .SYNOPSIS
        Download a file created by an export job
    .DESCRIPTION
        Download the file created by an export job
        Authority: User, Group Manager, Manager
    .EXAMPLE
        Get-RiskSenseExport -ClientID 1 -ExportID 1 -Token 'secrettoken'
    #>

    [CmdletBinding()]
    param(
        # ClientID
        [Parameter(Mandatory)]
        [int]$ClientID,

        # Export ID
        [Parameter(Mandatory)]
        [int]$ExportID,

        # File to save the export as
        [Parameter(Mandatory)]
        [string]$OutFile,

        # RiskSense API Key
        [Parameter(Mandatory)]
        $Token
    )

    begin {
        $headers = Get-AuthHeader $Token
    }

    process {
        Invoke-RestMethod -Uri "$uri/client/$ClientID/export/$ExportID" -Method Get -OutFile $OutFile -Headers $headers 
    }

    end {}
}
