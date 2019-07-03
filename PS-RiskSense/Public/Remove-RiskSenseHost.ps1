function Remove-RiskSenseHost {
    <#
    .SYNOPSIS
        Remove RiskSense Hosts
    .DESCRIPTION
        Delete hosts from RiskSense. 
    .EXAMPLE
        Remove-RiskSenseHost -ClientID 1 -HostID 1, 5, 10 -Token 'secrettoken'
    #>

    [CmdletBinding()]
    param(
        # ClientID
        [Parameter(Mandatory,
                   Position=0,
                   ValueFromPipelineByPropertyName)]
        [int]$ClientID,

        # HostID
        [Parameter(Mandatory,
            Position=1,
            ValueFromPipelineByPropertyName)]
        [Alias("ID")]
        [String[]]$HostID,

        # RiskSense API Key
        [Parameter(Mandatory)]
        $Token
    )

    begin {
        $headers = Get-AuthHeader $Token
        $hostTable = @()
    }

    process {
        # Build a table of each ClientID and HostID in a 1-to-1 relationship
        foreach ($id in $HostID) {
            $hostTable += [PSCustomObject]@{
                ClientID = $ClientID
                HostID = $id       
            }
        }
    }

    end {
        # Submit one job per ClientID by grouping the objects
        $hostTable | Group-Object ClientID | ForEach-Object {
            $body = @{
                filterRequest = @{
                    filters = @(@{
                        field = 'id'
                        exclusive = $false 
                        operator = 'IN'
                        value = $_.Group.HostID -join ','
                    })
                }
            } | ConvertTo-Json -Depth 10 -Compress
            $result = Invoke-RestMethod -Uri "$uri/client/$($_.Name)/host/delete" -Method Post -Body $body -Headers $headers
            [PSCustomObject]@{
                JobID = $result.id
                Created = Get-Date $result.created
            }
        }
    }
}