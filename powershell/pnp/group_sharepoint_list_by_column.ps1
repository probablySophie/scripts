param($group_column, $select_field_value, $list)

# Were we given a list, or just a list to get?
if ( $list.GetType().BaseType.ToString() -ne "Microsoft.Sharepoint.Client.SecurableObject" )
{
    $list = Get-PnPList -Identity $list;
}
# If our list is now null - give up
if ( $list -eq $null ) { return }

# Get the list's items
$list_items = Get-PnPListItem -List $list

$Global:found_groups = [PSCustomObject]@();

# TODO: if $group_column is null, list the groupable columns

# Pull our selected column (or the title) from the list item
function get_selected_val
{
    param($item)
    if ( $select_field_value -eq $null ) { return $item.FieldValues.Title }
    return $item.FieldValues[$select_field_value].ToString()
}

$i=0;
# For each item
foreach ( $list_item in $list_items )
{
    # Little percent bar :)
    $i++; $percent = [math]::floor(($i / $list_items.length) * 100)
	Write-Progress -Activity "Grouping $($list.Title) items" -Status "$percent% Complete:" -PercentComplete $percent

    $Local:group_name = "";
    if ( $list_item.FieldValues[$group_column] -ne $null )
    {
        $group_name = $list_item.FieldValues[$group_column];
    }
    $Local:group_index = -1;
    for ( $i = 0; $i -lt $found_groups.length; $i++ )
    {
        if ( $found_groups[$i].name -eq $group_name ) {
            $group_index = $i;
            break
        }
    }
    if ( $group_index -ne -1 ) {
        $found_groups[$group_index].items += (get_selected_val $list_item);
    } else {
        $found_groups += [PSCustomObject]@{
            name = $group_name;
            items = @( (get_selected_val $list_item) );
        };
    }
}
Write-Host "Found $($found_groups.length) groups"
return $found_groups


