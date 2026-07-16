
$fields = Get-PnPField -List $pnplist.id
[string[]]$selectFields = @();

foreach ( $field in $fields )
{
    if ($field.ReadOnlyfield -ne $false -or $field.InternalName.StartsWith("_") -or $field.Group -eq "_Hidden" ) { continue }
    $selectFields += $field.internalName;
}

$pnplistitems = Get-PnPListItem -List $pnplist.id -Fields $selectFields

Write-Host "Got $($pnplistitems.Length) list items"
