# Get everyone in the given 
$groupId = Read-Host "The Group's ID: ";
# This gets the group 'members', but really only gets foreign key IDs
$groupMembers = Get-MgGroupMember -GroupId $groupId -all

$users = @()
ForEach ($user in $groupMembers)
{
    $users += Get-MgUser -UserId $user.id
}

# Display the users as a table :)
$users | Format-Table -Property DisplayName, OfficeLocation, JobTitle

Write-Host "$($users.length) users in group`n"
