param ( [string] $ENV_FILE )

# If nothing, default ".env"
if ( $ENV_FILE -eq $null ) { $ENV_FILE = ".env" }


# Only try read the file if it actually exists
if ( Test-Path $ENV_FILE ) {
    get-content $ENV_FILE | foreach {
        $name, $value = $_.split('=')
        set-content env:\$name $value
    }
}
