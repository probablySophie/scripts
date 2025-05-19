
if ((Get-Command Disconnect-MgGraph -errorAction SilentlyContinue) -eq $null) {
    Write-Host "Did not find Microsoft Graph disconnect cmdlet"
}
else
{
    Disconnect-MgGraph
}

if ((Get-Command Disconnect-ExchangeOnline -errorAction SilentlyContinue) -eq $null) {
    Write-Host "Did not find Exchange online disconnect cmdlet"
}
else
{
    Disconnect-ExchangeOnline -Confirm:$false
}

Write-Host "Done"
