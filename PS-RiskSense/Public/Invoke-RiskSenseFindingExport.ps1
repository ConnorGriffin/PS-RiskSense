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

        # Filter on "Status"
        [ValidateSet('Open', 'Closed')]
        [string]$Status,

        # Filter on "Has Patch"
        [AllowNull()]
        [nullable[bool]]$HasPatch,

        # Filter on "Has Privilege Escalation or Remote Code Execution Exploits"
        [AllowNull()]
        [nullable[bool]]$HasPeRce,
        
        # RiskSense API Key
        [Parameter(Mandatory)]
        $Token
    )

    begin {
        $headers = Get-AuthHeader $Token
        $filters = @()

        if ($Status) {
            $filters += [PSCustomObject]@{
                field = 'generic_state'
                exclusive = $false
                operator = 'EXACT'
                value = $Status
            }
        }

        if ($HasPeRce -ne $null) {
            $filters += [PSCustomObject]@{
                field = 'has_pe_rce'
                exclusive = $false
                operator = 'EXACT'
                value = ([string]$HasPeRce).ToLower()
            }
        }

        if ($HasPatch -ne $null) {
            $filters += [PSCustomObject]@{
                field = 'has_patch'
                exclusive = $false
                operator = 'EXACT'
                value = ([string]$HasPatch).ToLower()
            }
        }

        $body = [PSCustomObject]@{
            filterRequest = [PSCustomObject]@{
                filters = $filters 
            }
            fileType = 'XLSX'
        } | ConvertTo-Json -Depth 99
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
