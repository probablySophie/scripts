param($connectionChoice, $suppressWelcome)

$ENV_FILE = ".env"
# Only try read the file if it actually exists
if ( Test-Path $ENV_FILE ) {
    get-content $ENV_FILE | foreach {
        $name, $value = $_.split('=')
        set-content env:\$name $value
    }
}

$GRAPH_SCOPES="User.ReadWrite.All","Group.ReadWrite.All"

if ( $PSBoundParameters.Keys.Count -eq 1 )
{
    switch ($connectionChoice)
    {
        "exchange" {

            Connect-ExchangeOnline -Device
        }
        "graph" {
            Write-Host "Importing Graph..."
            Import-Module Microsoft.Graph
            Write-Host "Connecting..."
            if (($suppressWelcome -ne $null ) -and ($suppressWelcome -eq $true))
            {
                Connect-MgGraph -Scopes $GRAPH_SCOPES -NoWelcome
            }
            else
            {
                Connect-MgGraph -Scopes $GRAPH_SCOPES
            }
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
