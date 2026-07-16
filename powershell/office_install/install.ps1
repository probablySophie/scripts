# This is based HEAVILY off of https://github.com/MSEndpointMgr/M365Apps/blob/main/VisioWin32App/InstallVisio.ps1
# The Microsoft Office installer requires having root access

$temp_path = "$($env:SystemRoot)\Temp\OfficeSetup";

if ( Test-Path "$temp_path" ) {
	Remove-Item -Path "$temp_path" -Recurse -Force -ErrorAction SilentlyContinue
}

$setup_path = (New-Item -ItemType "directory" -Path "$($env:SystemRoot)\Temp" -Name OfficeSetup -Force).FullName

$setup_exe_path = Join-Path "$setup_path" "\setup.exe";

curl.exe "https://officecdn.microsoft.com/pr/wsus/setup.exe" --output "$setup_exe_path"
if ( -not ( Test-Path "$setup_exe_path" ) ) {
	throw "Download of setup.exe failed";
}

Copy-Item "$($PSScriptRoot)\Visio.xml" $setup_path -Force -ErrorAction Stop

Start-Process "$setup_exe_path" -ArgumentList "/configure $( Join-Path $setup_path "Visio.xml" )" -Wait -PassThru -NoNewWindow

