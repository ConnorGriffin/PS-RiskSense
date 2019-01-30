function Get-RiskSenseClient {
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
        # RiskSense API Key
        [Parameter(Mandatory)]
        $Token
    )

    begin {
        $uri = 'https://platform.risksense.com/api/v1'
        $headers = Get-AuthHeader $Token
    }
    
    process {
        $result = Invoke-PaginatedRestMethod -Uri "$uri/client" -Headers $headers
        $result.clients.ForEach{
            [PSCustomObject]@{
                ID = $_.id
                UUID = $_.uuid
                Name = $_.name 
                RS3 = $_.rs3
                Contact = [PSCustomObject]@{
                    Address = $_.contact.address 
                    Address2 = $_.contact.address2 
                    City = $_.contact.city 
                    State = $_.contact.state 
                    ZIP = $_.contact.zip
                    Phone = $_.contact.phone 
                }
                ExpirationDate = if ($_.expirationDate) {Get-Date $_.expirationDate} else {$null}  
                Notes = $_.notes 
                Description = $_.Description 
                Industry = $_.industry
                Disabled = [System.Convert]::ToBoolean($_.disabled)
                DemoClient = [System.Convert]::ToBoolean($_.demoClient)
                AccountManagerId = $_.accountManagerId
            }
        }
    }

    end {}

}
