param($param1)

$ENV_FILE = ".env"
get-content $ENV_FILE | foreach {
    $name, $value = $_.split('=')
    set-content env:\$name $value
}

function Connect-Mg
{
    Connect-MgGraph -Scopes "User.ReadWrite.All","Group.ReadWrite.All"
}

if ( $PSBoundParameters.Keys.Count -eq 1 )
{
    switch ($param1)
    {
        "exchange" {

            Connect-ExchangeOnline -Device
        }
        "graph" {
            Import-Module Microsoft.Graph
            Connect-MgGraph -Scopes "User.ReadWrite.All","Group.ReadWrite.All"
        }
        "pnp" {
            Import-Module PnP.PowerShell
            Connect-PnPOnline -Url "$env:SharePointTenant.sharepoint.com" -Interactive  -ClientId "$env:PNPClientID"
        }
    }
}
else
{
    Write-Host "Options: "
    Write-Host "`t exchange "
    Write-Host "`t graph    "
    Write-Host "`t pnp      "
}
