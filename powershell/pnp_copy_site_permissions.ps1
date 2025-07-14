
# This script expects:
# * That you want to copy the site members group from your input site in its entirety
# * That there is a file at ./data/sites.txt that contains one site URL per line and that you would like each of those site member groups to have all of the members of your input site's members group

$Local:site = Read-Host -Prompt "Please enter a site who's permissions you'd like to copy from"

$ENV_FILE = ".env"
# Only try read the file if it actually exists
if ( Test-Path $ENV_FILE ) {
    get-content $ENV_FILE | foreach {
        $name, $value = $_.split('=')
        set-content env:\$name $value
    }
}

Connect-PnPOnline -Url "$($Local:site)" -Interactive  -ClientId "$env:PNPClientID"

$Local:siteGroups = Get-PnPGroup
$Local:selectedGroup = $siteGroups | Where-Object { $_.Title -like "*members*" }

$Local:members = Get-PnPGroupMember -Group $Local:selectedGroup;

get-content ./data/sites.txt | foreach {
    $Local:currentSite = $_;
    # Skip the site we're pulling from
    if ( $Local:currentSite -eq $site ) { return }

    Write-Host "$($currentSite)"
    
    Connect-PnPOnline -Url "$($Local:currentSite)" -Interactive  -ClientId "$env:PNPClientID"

    $memberGroup = Get-PnPGroup | Where-Object { $_.Title -like "*Members*" };
    $theseMembers = Get-PnPGroupMember -Group $memberGroup;

    $skipped = 0;
    $members | % {
        $loginName = $_.LoginName;
        if ( ($theseMembers | Select-Object { $_.LoginName -eq $loginName }).length -ne 0 ) {
            $skipped++;
            # Write-Host "Skipped";
            return
        }
        Add-PnPGroupMember -Group $memberGroup -LoginName $LoginName
        Write-Host "`tAdded $($_.Title)"
    }
    Write-Host "$skipped accounts skipped as they were already members of $($memberGroup.Title)";
    Write-Host "$( $members.length - $skipped ) accounts added to $($memberGroup.Title)"
}
