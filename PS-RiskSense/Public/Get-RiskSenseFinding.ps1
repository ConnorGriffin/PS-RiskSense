function Get-RiskSenseFinding {
    <#
    .SYNOPSIS
        Search for host findings.
    .DESCRIPTION
        List host findings (vulnerabilities) in a RiskSense client. 
        Authority: User, Group Manager, Manager
    .EXAMPLE
        Get-RiskSenseFinding -ClientID 1 -Token 'secrettoken'
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
            "filters": [
                {"field":"generic_state","exclusive":false,"operator":"EXACT","value":"Open"}
            ],
            "projection": "basic",
            "sort": [
              {
                "field": "id",
                "direction": "ASC"
              }
            ],
            "page": $page,
            "size": 1000
          }'
    }
    
    process {
        $page = 0
        do {
            $irmBody = $body.Replace('$page', $page)
            $result = Invoke-RestMethod -Uri "$uri/client/$ClientID/hostFinding/search" -Method Post -Body $irmBody -Headers $headers

            foreach ($finding in $result._embedded.hostFindings) {
                [PSCustomObject] @{
                    ID = $finding.id
                    ClientID = $ClientID
                    Title = $finding.title
                    Risk = $finding.Risk 
                    Severity = $finding.severity
                    xrs3Impact = $finding.xrs3Impact 
                    xrs3ImpactOnCategory = $finding.xrs3ImpactOnCategory
                    ScannerReported = $finding.ScannerReported
                    CVSSv2 = $finding.cvssv2
                    CVSSv3 = $finding.cvssv3
                    State = $finding.state 
                    GroupID = $finding.GroupId 
                    GroupIDs = $finding.GroupIds
                    PortID = $finding.portId
                    Hostname = $finding.hostname
                    IP = $finding.IP 
                    Criticality = $finding.Criticality 
                    IsExternal = $finding.IsExternal 
                    LastFoundOn = if ($finding.lastFoundOn) { Get-Date $finding.lastFoundOn } else { $null }
                    DiscoveredOn = if ($finding.discoveredOn) { Get-Date $finding.discoveredOn } else { $null }
                    ResolvedOn = if ($finding.resolvedOn) { Get-Date $finding.resolvedOn } else { $null }
                }
            }
            $page++
        } while ($result._links.next.href)
    }

    end {}
}
