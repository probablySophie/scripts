
# TODO: Take an optional list & optional connection as arguments
# TODO: Optionally save the list & connection for later use

$connection = $connection2;
$site = $site2;
$list = $list2;

$load_from = "Test Material Analysis Request Form"

$dir_name = "List_$load_from";

$ListInfo = Get-Content ".\$dir_name\List.json" | Out-String | ConvertFrom-Json;

$existing_fields = Get-PnPField -List $list -Connection $connection;
$i = 0;

# INFO: Importing the columns
foreach ( $column in $ListInfo.Columns )
{
    $i++;
    $percent1 = [math]::floor(($i / $ListInfo.Columns.length) * 100);
	Write-Progress -Activity "Creating Columns" -Status "$i/$($ListInfo.Columns.length): $($column.DisplayName)" -PercentComplete $percent1 -Id 1

    $existing_column = ( $existing_fields | ? { $_.InternalName -eq $column.InternalName } );

    # If the column doesn't exist - make it
    if ( $existing_column -eq $null )
    {
        Add-PnPField -List $list `
            -Connection $connection `
            -DisplayName $column.DisplayName `
            -InternalName $column.InternalName `
            -Type $column.Type
    }
    $differs = $false;
    
    $Values = [PSCustomObject]@{
        CustomFormatter=$column.CustomFormatter;
        Choices=[string[]]$column.Choices;
        Required=$column.Required;
        Description=$column.Description;
        DisplayName=$column.DisplayName;
        DefaultValue=$column.DefaultValue;
    }
    # Check if there's actually anything worth changing
    $Values.Keys | % {
        $key = $_;
        if ( ($existing_column.PSObject.Properties | ? { $_.Name -eq "$key" }) -eq $null ) {
            return
        }
        if ( ($existing_column[$_] -ne $Values[$_]) ) {
            $differs = $true;
        }
    }
    # If there are things to change - do it
    if ( $differs ) {
        Set-PnPField -List $list `
            -Identity $column.InternalName`
            -Connection $connection `
            -Values $Values
    }
}

$dir_contents = Get-Item ".\$dir_name\*" | % { $_.Name };

$existing_views = Get-PnPView -List $list -Connection $connection

$view_files = $dir_contents | ? { $_.StartsWith("View_") }
$content_type_files = $dir_contents | ? { $_.StartsWith("ContentType_") }

$i = 0;
# INFO: Importing the views
foreach ( $file in $view_files )
{
    $i++;
    $percent1 = [math]::floor(($i / $view_files.length) * 100);
	Write-Progress -Activity "Creating Views" -Status "$i/$($view_files.length): $file" -PercentComplete $percent1 -Id 1

    if ( $file -eq "List.json" ) { continue }
    if ( -not $file.EndsWith(".json") ) { continue }

    $ViewInfo = Get-Content ".\$dir_name\$file" | Out-String | ConvertFrom-Json;
    if ( $ViewInfo.ViewName -eq $null ) { continue }

    $existing_view = ( $existing_views | ? { $_.Title -eq $ViewInfo.ViewName } );

    # If the view doesn't exist - create it
    if ( $existing_view -eq $null )
    {
        Add-PnPView -List $list `
            -Connection $connection `
            -Title $ViewInfo.ViewName `
            -Query $ViewInfo.ViewQuery `
            -Fields $ViewInfo.ViewFields `
            -ViewType $ViewInfo.ViewType `
            -RowLimit $ViewInfo.RowLimit `
            -Personal:$false `
            -SetAsDefault:$false `
            -Paged:$ViewInfo.Paged `
            -Aggregations $ViewInfo.Aggregations `
    }

    $Values = [PSCustomObject]@{
            CustomFormatter = $ViewInfo.Formatter;
            ViewData = $ViewInfo.ViewData;
            ViewType2 = $ViewInfo.ViewType2;
            Scope = [Microsoft.SharePoint.Client.ViewScope]$viewInfo.Scope; # Whether to recurse into folders
            Hidden = $viewInfo.Hidden; # Are we a secret!?
            TabularView = $viewInfo.TabularView; # ???
        }
    $differs = $false;

    # Do we actually need to make any changes
    $Values.Keys | % {
        $key = $_;
        if ( ($existing_view.PSObject.Properties | ? { $_.Name -eq "$key" }) -eq $null ) {
            return
        }
        if ( ($existing_view[$_] -ne $Values[$_]) ) {
            $differs = $true;
        }
    }
    if ( $differs ) {
        # Update the view!
        Set-PnPView `
            -Connection $connection `
            -List $list `
            -Fields $ViewInfo.ViewFields `
            -Identity $ViewInfo.ViewName `
            -Values $Values
    }
}

# Updating content types - useful for the new item form
$i = 0;
foreach ( $file in $content_type_files )
{
    $i++;
    $percent1 = [math]::floor(($i / $content_type_files.length) * 100);
	Write-Progress -Activity "Updating content types" -Status "$i/$($content_type_files.length): $file" -PercentComplete $percent1 -Id 1

    if ( -not $file.EndsWith(".json") ) { continue }

    $ContentTypeInfo = Get-Content ".\$dir_name\$file" | Out-String | ConvertFrom-Json;
    if ( $ContentTypeInfo.ClientFormCustomFormatter -eq $null ) { continue }

    if ( $ContentTypeInfo.Name -eq "Folder" ) { continue }

    $content_type = Get-PnPContentType -List $list -Connection $connection -Identity $ContentTypeInfo.Name
    $content_type.ClientFormCustomFormatter = $ContentTypeInfo.ClientFormCustomFormatter;
    $content_Type.Update($false);
}
