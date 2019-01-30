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
              {
                "field": "id",
                "exclusive": false,
                "operator": "WILDCARD",
                "value": "*"
              }
            ],
            "projection": "basic",
            "sort": [
              {
                "field": "id",
                "direction": "ASC"
              }
            ],
            "page": $page,
            "size": 2000
          }'
    }
    
    process {
        $page = 0
        do {
            $irmBody = $body.Replace('$page', $page)
            $result = Invoke-RestMethod -Uri "$uri/client/$ClientID/host/search" -Method Post -Body $irmBody -Headers $headers
            $result._embedded.hosts
            $page++
        } while ($result._links.next.href)
    }

    end {}
}
