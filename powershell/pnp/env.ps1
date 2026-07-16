# INFO: We're expecting:
# PNP_CLIENT_ID=Entra app client id
# PNP_TENANT_ID=Sharepoint tennant id (e.g. nasa.sharepoint.com -> nasa)

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
