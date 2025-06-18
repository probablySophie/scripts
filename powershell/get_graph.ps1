param ( $choice )
Write-Host ""

function __found_nothing
{
    Write-Host "No input given, choices are:";
    Write-Host "`t site";
    Write-Host "`t list";
    Write-Host "`t listitems"
}
if ( $choice -eq $null ) {
    __found_nothing
    return
}

function print_if_not_null
{
    param($value, $variable_name)
    if ( $value -eq $null ) {
        Write-Host "Something went wrong!  `$$variable_name is null";
    } else {
        $value
        Write-Host "Storing in `$$variable_name";
    }
}

switch ($choice.ToLower())
{
    "site" {
        # Get a site name from the user & search for it
        $sites = Get-MgSite -search "$(Read-Host -Prompt 'Site Display Name')";
        # For each site, make a custom object with the site's index number & display it
        $sites `
            | % {$i=0}{ [PsCustomObject]@{Num=$i;Name=$_.DisplayName;URL=$_.WebUrl} ;$i++} `
            | Format-Table;
        # Then ask the user which index they'd like
        $site = $sites[$(Read-Host -Prompt "Your Chosen Site's num")];
        # And output it for them :)
        print_if_not_null $site "site"
    }

    "list" {
        if ($site -eq $null) {
            Write-Host "`$site is null!  Exiting";
            return
        }
        Write-Host "`nGetting lists from site '$($site.DisplayName)'";
        $__filter = Read-Host -Prompt 'Display Name Filter (blank for all)';
        $siteLists = Get-MgSiteList -SiteID $site.ID -All | Where-Object { $_.DisplayName -like "*$($__filter)*" };
        $siteLists `
            | % {$i=0}{ [PsCustomObject]@{Num=$i;Name=$_.DisplayName;URL=$_.WebUrl} ;$i++} `
            | Format-Table;
        $list = $siteLists[$(Read-Host -Prompt "Your Chosen List's num")];
        print_if_not_null $list "list"
    }

    "listitems" {
        if ($site -eq $null) {
            Write-Host "`$site is null!  Exiting";
            return
        }
        if ($list -eq $null) {
            Write-Host "`$list is null!  Exiting";
            return
        }
        $listItems = Get-MgSiteListItem -SiteId $site.id -ListId $list.id -All -ExpandProperty Fields
        Write-Host "Stored $($listItems.length) items from '$($list.DisplayName)' into `$listItems"
    }

    # Remember to add any nre items to the start of file options list!
    default {
        __found_nothing
    }
}


# Remove-Variable __found_nothing
# Remove-Variable print_if_not_null
