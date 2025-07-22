param ( $choice )
Write-Host ""

function __found_nothing
{
    Write-Host "No input given, choices are:";
    Write-Host "`t site";
    Write-Host "`t list";
    Write-Host "`t listitems"
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

function get_pnp()
{
    param($choice)
    switch ($choice.ToLower())
    {
        "site" {
            # Connect to a given site URL
            Connect-PnPOnline -Url "$(Read-Host -Prompt 'Site URL')" -Interactive  -ClientId "$env:PNPClientID"
            $Global:pnpsite = Get-PnpWeb
            Write-Host "Saved site into `$pnpsite";
        }

        "list" {
            # Make sure there's a site to pull from
            if ( $pnpsite -eq $null ) { Write-Host "`$pnpsite is null!"; get_pnp "site"; }
        
            $__filter = Read-Host -Prompt 'Display Name Filter (blank for all)';

            $pnplists = Get-PnpList | Where-Object { $_.Title -like "*$($__filter)*" }
        
            $pnplists `
                | % {$i=0}{ [PsCustomObject]@{Num=$i;Name=$_.Title;} ;$i++} `
                | Format-Table;
            # Then ask the user which index they'd like
            $Global:pnplist = $pnplists[$(Read-Host -Prompt "Your chosen list's num")];
            Write-Host "Saved '$($pnplist.Title)' into `$pnplist";
        }

        "listitems" {
            # Make sure there's a site & a list to pull from
            if ( $pnplist -eq $null ) { Write-Host "`$pnplist is null!"; get_pnp "list"; }

            $Global:pnplistitems = Get-PnpListItem -List $pnplist;
            Write-Host "Saved $($pnplistitems.Length) items from '$($pnplist.Title)' into `$pnplistitems";
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
        0 { get_pnp "site" }
        1 { get_pnp "list" }
        2 { get_pnp "listitems" }
    }
} else {
    get_pnp "$choice"
}

