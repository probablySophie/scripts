param( $apps )

# VisioProRetail

if ( $apps -eq $null ) { throw "Expected positional argument 1 containing a string or string[] with apps to remove" }

$REMOVE_LINE='<Product ID="{{SOFTWARE}}"> </Product>'
$XML='<Configuration>
	<Display Level="Full" AcceptEULA="TRUE"/>
	<Property Name="FORCEAPPSHUTDOWN" Value="TRUE"/>
	<Remove>
		{{TO_REMOVE}}
	</Remove>
</Configuration>'

function build_xml
{
    param( [object]$apps, [string]$save_to )
    if ( -not ( $apps -is [array] ) ) { $apps = @( $apps ); }

    $LINES = "";
    foreach ( $item in $apps )
    {
        if ( $item.GetType().Name -ne "string" ) { continue }
        if ( $LINES.Length -gt 0 ) { $LINES += "`n" }
        $LINES += $REMOVE_LINE.Replace( "{{SOFTWARE}}", $item );
    }
    $XML.Replace( "{{TO_REMOVE}}", "$LINES" ) | Out-File -FilePath "$save_to";
    return $save_to;
}

$temp_path = "$($env:SystemRoot)\Temp\OfficeSetup";

# If someone else didn't clean up after themselves, do it for them
if ( Test-Path "$temp_path" ) { Remove-Item -Path "$temp_path" -Recurse -Force -ErrorAction SilentlyContinue }

$setup_path = (New-Item -ItemType "directory" -Path "$($env:SystemRoot)\Temp" -Name OfficeSetup -Force).FullName

$setup_exe_path = Join-Path "$setup_path" "\setup.exe";
# Download setup.exe from the permenant URL Microsoft have
curl.exe "https://officecdn.microsoft.com/pr/wsus/setup.exe" --output "$setup_exe_path"
if ( -not ( Test-Path "$setup_exe_path" ) ) { throw "Download of setup.exe failed"; }

$xml_path = build_xml $apps "$temp_path\uninstall.xml";

Start-Process "$setup_exe_path" -ArgumentList "/configure $xml_path" -Wait -PassThru -NoNewWindow

# Clean up after ourself
Remove-Item -Path "$temp_path" -Recurse -Force -ErrorAction SilentlyContinue
