param($param1)

function Connect-Mg
{
    Connect-MgGraph -Scopes "User.ReadWrite.All","Group.ReadWrite.All"
}

if ( $PSBoundParameters.Keys.Count -eq 1 )
{
    switch ($param1)
    {
        "exchange" { Connect-ExchangeOnline -Device }
        "graph" { Connect-MgGraph -Scopes "User.ReadWrite.All","Group.ReadWrite.All" }
    }
}
else
{
    Write-Host "Options: "
    Write-Host "`t exchange "
    Write-Host "`t graph    "
}
