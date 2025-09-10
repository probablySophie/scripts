param($val)

if ( $val -eq $null ) {
    Write-Host "Given value is null";
    return $null
}

$content_type_id = "";
if ( $val.GetType().Name -eq "String" ) {
    $content_type_id = $val;
} else {
    if ( $val.ContentType -eq $null ) { return }
    if ( $val.ContentType.Id -eq $null ) { return }
    if ( $val.ContentType.Id.StringValue -eq $null ) { return }
    $content_type_id = $val.ContentType.Id.StringValue;
}

$content_types = Get-PnPContentType -Includes Fields;
$matches = $content_types | Where-Object { $content_type_id.StartsWith( $_.Id.StringValue ) }

$current_best = $matches[0];

foreach( $match in $matches ) {
    # Perfect match??
    if ( $match.Id.StringValue -eq $content_type_id ) {
        $current_best = $match;
        break
    }
    if ( $match.Id.StringValue.length -gt $current_best.Id.StringValue.length ) {
        $current_best = $match;
    }
}

return $current_best

