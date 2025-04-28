clear

# Connect-MgGraph -Scopes "Sites.Read.All"
$DOMAIN = Read-Host -p "Please enter your sharepoint's domain (DOMAIN.sharepoint.com): ";
$SITE_ID_URL = ".sharepoint.com:/sites/"

function Make-SiteId {
	param ( $SiteName )
	return "$($DOMAIN)$($SITE_ID_URL)$($SiteName)"
}

# INFO:: Enter your sites here:
$SITES = @('site1', 'site1/subsite', 'site2')

$SiteDataCollection = @()

foreach ($site in $SITES) {
	Write-Output "" (Make-SiteId $site)
	
	# Import-Module Microsoft.Graph.Sites

	# # Gives access denied
	#Get-MgAllSite

	# Get-MgSite -Property "siteCollection,webUrl" -Search "true"

	# # This works!!
	# Get-MgSite -SiteId "DOMAIN.sharepoint.com:/sites/SITENAME"
	Write-Output "`tGetting Site Data"
	$SiteData = Get-MgSite -SiteId (Make-SiteId $site)
	$SiteDataCollection += $SiteData
	# DisplayName
	# WebUrl
	# Id
	Write-Output "`tPolling Drives"
	$drives = Get-MgSiteDrive -SiteId $SiteData.Id

	foreach ($drive in $drives) {
		if ( $drive.Name -eq "Pages" )
		{
			Write-Output "`tPulling Files"
			$files = Get-MgDriveItem -DriveId $drives[1].Id -Filter "true" -All
			Write-Output "`tSaving CSV"
			$files | Select-Object -Property Name, WebUrl | Export-Csv -Path ".\$($site.Replace("/", "_")).csv"
		}
	}

	# Name
	# WebUrl
}

$SiteDataCollection | Select-Object -Property Name, WebUrl, DisplayName | Export-Csv -Path ".\Sites.csv"

