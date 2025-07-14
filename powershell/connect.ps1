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

function Connect
{
    param($connectionChoice, $suppressWelcome)
    switch ($connectionChoice)
    {
        "exchange" {
            Write-Host "Connecting to Exchange Online..."
            Connect-ExchangeOnline -Device
        }
        "graph" {
            # Write-Host "Importing Graph..."
            # Import-Module Microsoft.Graph
            Write-Host "Connecting to Microsoft Graph..."
            if (($suppressWelcome -ne $null ) -and ($suppressWelcome -eq $true))
            {
                Connect-MgGraph -Scopes $GRAPH_SCOPES -NoWelcome -UseDeviceCode
            }
            else
            {
                Connect-MgGraph -Scopes "User.ReadWrite.All","Group.ReadWrite.All" -UseDeviceCode
            }
        }
        "pnp" {
            Write-Host "Connecting to Microsoft PnP..."
            Import-Module PnP.PowerShell
            Connect-PnPOnline -Url "$env:SharePointTenant.sharepoint.com" -Interactive  -ClientId "$env:PNPClientID"
        }
    }
    
}

if ( $PSBoundParameters.Keys.Count -eq 1 )
{
    Connect "$connectionChoice" "$suppressWelcome"
}
else
{
    Write-Host "Options: "
    Write-Host "`t exchange "
    Write-Host "`t graph    "
    Write-Host "`t pnp      "

    $options = [System.Management.Automation.Host.ChoiceDescription[]](
        (New-Object System.Management.Automation.Host.ChoiceDescription "&Graph", "Microsoft Graph"),
        (New-Object System.Management.Automation.Host.ChoiceDescription "&Exchange", "Microsoft Exchange"),
        (New-Object System.Management.Automation.Host.ChoiceDescription "&PnP", "Microsoft PnP") )
    $result = $host.ui.PromptForChoice("Connect", "Which service would you like to connect to?", $options, 0)
    switch ($result) {
        0 { Connect "graph" }
        1 { Connect "exchange" }
        2 { Connect "pnp" }
    }
}
