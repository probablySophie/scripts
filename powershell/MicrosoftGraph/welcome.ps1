#!/bin/pwsh
# Write-Host ""

# Create a profile.ps1 file
echo "
function Quit { Invoke-command -ScriptBlock {exit} }
Set-Alias -Name q -Value Quit
" > ~/.config/powershell/profile.ps1

cd /graph
/bin/pwsh
