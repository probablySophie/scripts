param ( $choice )
Write-Host ""

function __found_nothing
{
    Write-Host "No input given, choices are:";
    Write-Host "`t site";
    Write-Host "`t list";
    Write-Host "`t listitems"
}

# Make sure we're signed in
if ( (Get-MgContext) -eq $null ) {
    Write-Host "Not currently connected to Microsoft Graph.  Exiting..."
    return
}

function GetGraph
{
    param($choice)
    switch ($choice.ToLower())
    {
        "site" {
            # Get a site name from the user & search for it
            $sites = Get-MgSite -search "$(Read-Host -Prompt 'Site Display Name')";
            if ( $sites -eq $null ) { return }
            # Filter down to one site
            $result = . "./utils/sp_chooseFromList.ps1" $sites "Site"
            if ( $result -ne $null ) {
                $Global:site = $result;
                Write-Host "The variable `$site now contains the site: $($Global:site.displayName)"
            }
            else { Write-Host "Something went wrong. Did not change variable `$site" }
            return
        }

        "list" {
            if ($Global:site -eq $null) { GetGraph "site" }
            if ($Global:site -eq $null) { Write-Host "Site was still null.  Exiting"; return }
            else {
                $result = . "./utils/choice.ps1" @( @("Yes", "Yes"), @("No", "No") ) "Use Site?" "Would you like to use the Site $($Global:site.DisplayName)?";
                if ( $result -eq 1 ) { GetGraph "site" }
            }

            # Get a site name from the user & search for it
            $lists = Get-MgSiteList -SiteId $Global:site.id -All;
            # Filter down to one site
            $result = . "./utils/sp_chooseFromList.ps1" $lists "List"
            Write-Host $result
            if ( $result -ne $null ) {
                $Global:list = $result;
                Write-Host "The variable `$list now contains the list: $($result.displayName)"
            }
            else { Write-Host "Something went wrong. Did not change variable `$list" }
            return
        }

        "listitems" {
            if ($Global:list -eq $null) { Write-Host "`$list is empty"; GetGraph "list" }
            if ($Global:list -eq $null) { Write-Host "`$list is still empty"; return }
            else {
                $result = . "./utils/choice.ps1" @( @("Yes", "Yes"), @("No", "No") ) "" "Would you like to get items from the list $($Global:list.DisplayName)?";
                if ( $result -eq 1 ) { GetGraph "list" }
            }
            
            $Global:listItems = Get-MgSiteListItem -SiteId $site.id -ListId $list.id -All -ExpandProperty Fields
            Write-Host "Stored $($listItems.length) items from '$($list.DisplayName)' into `$listItems"
            return
        }

        # Remember to add any nre items to the start of file options list!
        default {
            __found_nothing
        }
    }
}

if ( $choice -eq $null ) {
    __found_nothing

    $options = [System.Management.Automation.Host.ChoiceDescription[]](
        (New-Object System.Management.Automation.Host.ChoiceDescription "&Site", "A SharePoint Site"),
        (New-Object System.Management.Automation.Host.ChoiceDescription "&List", "A SharePoint Site List"),
        (New-Object System.Management.Automation.Host.ChoiceDescription "&Items", "Items from a SharePoint list") )
    $result = $host.ui.PromptForChoice("Get-Graph", "Which would you like to get?", $options, 0)
    switch ($result) {
        0 { GetGraph "site" }
        1 { GetGraph "list" }
        2 { GetGraph "listitems" }
    }
} else {
    GetGraph "$choice"
}

# Remove-Variable __found_nothing
# Remove-Variable print_if_not_null
