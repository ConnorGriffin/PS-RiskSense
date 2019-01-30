function Invoke-PaginatedRestMethod {
    [CmdletBinding()]
    Param(
        $Uri,
        $Method='Get',
        $Headers
    )
    begin{
        $r = $null
    }
    process {
        do {
            if ($r._links.next.href) {
                $Uri = $r._links.next.href
            }
            $r = Invoke-RestMethod -Uri "$Uri" -Method $Method -Headers $Headers
    
            $r._embedded
        } while ($r._links.next.href)
    }
}

