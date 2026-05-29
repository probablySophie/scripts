function or_existing
{
    param( $prompt, $default )
    if ( $default -ne $null ) {
        # return $default
        $tmp = Read-Host "$prompt (or blank for '$default')";
        if ( $tmp.Trim() -eq "" ) { return $default }
        return $tmp
    }
    return Read-Host "$prompt"
}

