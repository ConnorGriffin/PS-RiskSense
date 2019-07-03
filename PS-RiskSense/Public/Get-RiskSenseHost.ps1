function Get-RiskSenseHost {
    <#
    .SYNOPSIS
        List clients
    .DESCRIPTION
        List clients in RiskSense. 
        Authority: Technician, User, Group Manager, Manager
    .EXAMPLE
        Get-RiskSenseClient
    #>

    [CmdletBinding()]
    param(
        # ClientID
        [int]$ClientID,
        
        # RiskSense API Key
        [Parameter(Mandatory)]
        $Token
    )

    begin {
        $headers = Get-AuthHeader $Token
        $body = '{
            "filters": [
            ],
            "projection": "basic",
            "sort": [
              {
                "field": "id",
                "direction": "ASC"
              }
            ],
            "page": $page,
            "size": 250
          }'
    }
    
    process {
        $page = 0
        do {
            $irmBody = $body.Replace('$page', $page)
            $result = Invoke-RestMethod -Uri "$uri/client/$ClientID/host/search" -Method Post -Body $irmBody -Headers $headers
            foreach ($rsHost in $result._embedded.hosts) {
                try {
                    $lastFoundOn = (Get-Date $rsHost.lastFoundOn)
                } catch {
                    $lastFoundOn = $rsHost.lastFoundOn
                }

                [PSCustomObject] @{
                    ID = $rsHost.id
                    ClientID = $rsHost.ClientID
                    RS3 = $rsHost.rs3 
                    Criticality = $rsHost.criticality 
                    TagIDs = $rsHost.tagIds 
                    NetworkId = $rsHost.networkIds 
                    FindingsDistribution = $rsHost.findingsDistribution 
                    DiscoveredOn = (Get-Date $rsHost.discoveredOn)
                    LastFoundOn = $lastFoundOn
                    LastScanTime = (Get-Date $rsHost.lastScanTime)
                    HostName = $rsHost.hostname 
                    IPAddress = $rsHost.ipAddress 
                    OperatingSystemScanner = $rsHost.operatingSystemScanner
                    External = [System.Convert]::ToBoolean($rsHost.external) 
                    ConfigurationManagementDB = $rsHost.configurationManagementDB
                }
            }
            $page++
        } while ($result._links.next.href)
    }

    end {}
}
