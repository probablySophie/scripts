$scopes = "User.ReadWrite.All","Group.ReadWrite.All";
if ( ! ( . "$PSScriptRoot/../MicrosoftGraph/check_context.ps1" $scopes ) ) {
    Connect-MgGraph -Device -Scopes $scopes
}
if ( ( Get-ConnectionInformation ) -eq $null ) {
    Connect-ExchangeOnline -Device
}

$permissions = Import-Csv "$PSScriptRoot/data/permissions.csv"

function or_existing
{
    param( $prompt, $default )
    if ( $default -ne $null ) {
        # return $default
        $tmp = Read-Host "$prompt (or blank for '$default')";
        if ( $tmp.Trim() -eq "" ) { return $default }
        return $tmp
    }
    return Read-Host "$prompt"
}

$user_prev = $user_input;
$user_input = or_existing "Your User" $user_input
$user = if ( ( $user -ne $null ) -and ($user_prev -eq $user_input ) ) { $user } elseif ( $user_input.IndexOf( "@" ) -ne -1 ) {
    Get-MgUser -UserId "$user_input" -Select DisplayName, Company, Department, OfficeLocation, UserPrincipalName, Id
} else {
    Get-MgUser -Filter "(accountEnabled eq true) and (UserType eq 'Member') and (displayName eq '$user_input')" -Select DisplayName, Company, Department, OfficeLocation, UserPrincipalName, Id
}
if ( $user -eq $null -or $user.GetType().Name -ne "MicrosoftGraphUser" ) {
    Write-Error "Failed to get user from input '$user_input'";
    exit
}

$teams = $permissions | ? { ( $_.location -eq $user.OfficeLocation ) -or ( $_.location -eq "*" ) } | % { $_.team } | Sort-Object | Get-Unique;

# The mythical matching department/team??
if ( ( $teams | ? { $_ -eq $user.Department } ) -ne $null )
{
    $TEAM = $user.Department
}
else
{
    $i = 0;
    Write-Host -ForegroundColor Yellow "What team is your user in?";
    foreach ( $team in $teams ) { Write-Host "$i $team"; $i++ }
    $first = $true;
    while ( $first -eq $true -or (($ans -lt 0 -or $ans -ge $teams.Length) -and $ans -ne "q") ) { $first = $false; $ans = or_existing "Team" $ans }
    if ( $ans.Trim() -eq "q" ) {
        $TEAM = $null;
    } else {
        $TEAM = $teams[$ans];
    }
}

foreach ( $permission in $permissions )
{
    if ( ( $permission.team -ne $TEAM ) -and ( $permission.team -ne "*" ) ) { continue }
    if ( ( $permission.location -ne $user.OfficeLocation ) -and ( $permission.location -ne "*" ) ) { continue }

    # Because something was going wrong for... some reason?
    $permission.'ID/Address' = $permission.'ID/Address'.Replace('"', "");

    Write-Host "$($permission.description)"

    if ( $permission.type -eq "mailbox" -or $permission.type -eq "resource" )
    {
        if ( $permission.readwrite -and (Get-MailboxPermission -Identity $permission."ID/Address" -User $user.UserPrincipalName ) -eq $null ) {
            Write-Host "`tReadWrite"
            Add-MailboxPermission -Identity "$($permission.'ID/Address')" -User "$($user.UserPrincipalName)" -AccessRights FullAccess -InheritanceType All -Confirm:$false;
        }
        if ( $permission.sendas -and (Get-RecipientPermission -Identity $permission."ID/Address" -Trustee $user.UserPrincipalName ) -eq $null ) {
            Write-Host "`tSendAs"
            Add-RecipientPermission "$($permission.'ID/Address')" -AccessRights SendAs -Trustee "$($user.UserPrincipalName)" -Confirm:$false
        }
    }
    elseif ( $permission.type -eq "group" )
    {
        if ( ( Get-MgGroupMember -GroupId $permission."ID/Address" -Filter "id eq '$($user.Id)'" -ErrorAction Ignore ) -eq $null ) {
            Write-Host "`tAdding to group";
            New-MgGroupMemberByRef -GroupId $permission."ID/Address" -BodyParameter @{ "@odata.id" = "https://graph.microsoft.com/v1.0/directoryObjects/$($user.Id)" }
        }
    }
    elseif ( $permission.type -eq "distribution" ) {
        Add-DistributionGroupMember -Identity $permission."ID/Address" -Member $user.UserPrincipalName
            Write-Host "`tAdding to distribution list"
    }
    else { Write-Error "Unhandled permission type '$($permission.type)'" }
}
