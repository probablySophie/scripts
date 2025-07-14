# If your list is @{Title="Hi"}, @{Title="Bye"} then $itemNameVar should be "Title"

param(
    [array] $list, # The list you'd like to select from
    [string] $itemNameVar, # The list items' variable to display & filter by
    [boolean] $shouldFilter # Do we want to filter first?
)

$Local:list2 = $null;
if ($shouldFilter) {
    $Local:filter = Read-Host -Prompt "Enter text to filter the $itemNameVar by (or press enter for all)";
    $list2 = $list | Where-Object { $_."$itemNameVar" -like "*$($Local:filter)*" }
} else {
    $list2 = $list;
}
# If we no longer have an array, then return what we have
if ( -not ($list2 -is [array]) )
{
    return $list2
}
# Else, prompt for a selection

$Local:list2 `
    | % { $i = 0 }{
      [PsCustomObject]@{
        Num = $i;
        Name = $_."$itemNameVar";
      }
      $i++;
    } | Format-Table | Out-String | % { Write-Host $_ }

return $Local:list2[$(Read-Host -Prompt "Enter the Number for the item you'd like" )]
