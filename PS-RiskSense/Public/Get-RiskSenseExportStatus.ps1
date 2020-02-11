function Get-RiskSenseExportStatus {
    <#
    .SYNOPSIS
        Check status of an export job
    .DESCRIPTION
        Check status of an export job
        Authority: User, Group Manager, Manager
    .EXAMPLE
        Get-RiskSenseExportStatus -ClientID 1 -ExportID 1 -Token 'secrettoken'
    #>

    [CmdletBinding()]
    param(
        # ClientID
        [Parameter(Mandatory)]
        [int]$ClientID,

        # Export ID
        [Parameter(Mandatory)]
        [int]$ExportID,

        # RiskSense API Key
        [Parameter(Mandatory)]
        $Token
    )

    begin {
        $headers = Get-AuthHeader $Token
    }

    process {
        $result = Invoke-RestMethod -Uri "$uri/client/$ClientID/export/$ExportID/status" -Method Get -Headers $headers 
        [PSCustomObject]@{
            ID = $result.id 
            Filename = $result.filename
            Status = $result.status
        }
    }

    end {}
}
