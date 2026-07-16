
$all_lists = Get-PnPList;
$filter_text = Read-Host -Prompt "Filter by: ";

$pnplist = $all_lists | ? { $_.Title -like "*$($filter_text)*" }

if ( $pnplist -eq $null ) {
    Write-Error "Got null";
    exit
}
if ( $pnplist.GetType().Name -eq "Object[]" ) {
    $pnplist | % { [int]$i = 0 } { Write-Host "$i - $($_.Title)"; $i++ }
    $selection = Read-Host -Prompt "Which would you like?"
    $pnplist = $pnplist[ $selection ]
}
Write-Host "Saved $($pnplist.Title) into $$pnplist"
