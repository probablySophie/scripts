param( $obj, $path )

# A super simple Export-Csv wrapper that (sometimes) doesn't end up with a bunch of System.Object[] fields

$obj | % {
    $Local:item = $_;
    $Local:new_item = @{};
    $_ | Get-Member -MemberType NoteProperty | % {
        if ( $item.($_.Name) -is [Array] ) {
            $item.($_.Name) = ($item.($_.Name) | Out-String).ReplaceLineEndings("; ");
        }
    }
    return $item
} | Export-Csv -Path $path

Write-Host "Saved $path"

