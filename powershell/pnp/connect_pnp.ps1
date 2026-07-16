# Check first if we're in the directory's parent
if ( Test-Path "pnp/.env" ) {
    get-content pnp/.env | foreach {
        $name, $value = $_.split('=')
        set-content env:\$name $value
    }
} elseif ( Test-Path ".env" ) {
    get-content .env | foreach {
        $name, $value = $_.split('=')
        set-content env:\$name $value
    }
}

$connect_to = Read-Host -Prompt "Enter a site url or leave blank for default"
if ( $connect_to -eq "" ) { $connect_to = "$($env:PNP_TENANT_ID).sharepoint.com" }

if ( $connect_to.StartsWith("https://") -or $connect_to.StartsWith($env:PNP_TENANT_ID) ) {
    # Do nothing
}
elseif ( $connect_to.StartsWith("/sites") -or $connect_to.StartsWith("sites/") )
{
    if ( $connect_to -match "sites/(.*)" ) {
        $connect_to = "https://$($env:PNP_TENANT_ID).sharepoint.com/sites/$($matches[1])";
    } else {
        Write-Error "Bad input '$connect_to'";
        exit
    }
}
elseif ( $connect_to.IndexOf("/") -eq -1 ) {
    $connect_to = "$($env:PNP_TENANT_ID).sharepoint.com/sites/$connect_to"
}

$connection = Connect-PnPOnline -Url $connect_to -DeviceLogin -ClientId $env:PNP_CLIENT_ID

Get-PnPWeb

return $connection
