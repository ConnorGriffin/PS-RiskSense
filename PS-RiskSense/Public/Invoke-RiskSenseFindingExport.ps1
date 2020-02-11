function Invoke-RiskSenseFindingExport {
    <#
    .SYNOPSIS
        Initiate export job
    .DESCRIPTION
        Endpoint for initiating an export job against the data outlined in the given FilterRequest
        Authority: User, Group Manager, Manager
    .EXAMPLE
        Invoke-RiskSenseFindingExport -ClientID 1 -Token 'secrettoken'
    #>

    [CmdletBinding()]
    param(
        # ClientID
        [Parameter(Mandatory)]
        [int]$ClientID,
        
        # RiskSense API Key
        [Parameter(Mandatory)]
        $Token
    )

    begin {
        $headers = Get-AuthHeader $Token
        $body = '{
          "filterRequest": {
            "filters": [
                {"field":"generic_state","exclusive":false,"operator":"EXACT","value":"Open"}
            ]
          },
          "fileType": "XLSX"
        }'
    }

    process {
         $result = Invoke-RestMethod -Uri "$uri/client/$ClientID/hostFinding/export" -Method Post -Body $body -Headers $headers
         [PSCustomObject]@{
             ID = $result.id
             Created = Get-Date $result.created
         }
    }

    end {}
}
