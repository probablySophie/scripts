
# TODO: Take an optional list & optional connection as arguments
# TODO: Optionally save the list & connection for later use

$views = Get-PnPView -List $pnplist
$Columns = Get-PnPField -List $pnplist | % { [PSCustomObject]@{ DisplayName=$_.Title; InternalName = $_.InternalName; CustomFormatter=$_.CustomFormatter; Type= $_.TypeAsString; Required = $_.Required; Choices=$_.Choices; DefaultValue=$_.DefaultValue; Description=$_.Description } }

$export_list_views = [PSCustomObject]@{
    List=$pnplist;
    Connection;
}

$dir_name = "List_$($pnplist.title)";

$content_types = Get-PnPProperty -ClientObject $pnplist ContentTypes

# If the directory doesn't exist - make it
if ( (Get-Item ".\$dir_name" -ErrorAction SilentlyContinue) -eq $null )
{
    New-Item -Name $dir_name -ItemType Directory
}

# INFO: Exporting the list views
foreach ($view in $views)
{
    $ViewFields = $view.ViewFields | % { $_ }

    # Ignore forms
    # if ( $view.ViewType2 -eq "FORMS" ) { continue }

    [PSCustomObject]@{
        ViewName=$view.Title;
        Formatter=$view.CustomFormatter;
        ViewFields=$view.ViewFields;
        ViewData=$view.ViewData;
        ViewType=$view.ViewType;
        ViewType2=$view.ViewType2;
        ViewQuery=$view.ViewQuery;
        Scope=$view.Scope.ToString(); # Whether to recurse into folders
        Hidden=$view.Hidden; # Are we a secret!?
        TabularView=$view.TabularView; # ???
        Aggregations=$view.Aggregations;
        AggregationStatus=$view.AggregationStatus;
        Paged=$view.Paged;
        RowLimit=$view.RowLimit;
        
    } | ConvertTo-Json -Depth 10 > ".\$dir_name\View_$($view.Title).json";
}

# INFO: Exporting the list's content types - the content types store the new item field customisations
foreach ($content_type in $content_types)
{
    $content_type_fields = Get-PnpProperty -ClientObject $content_type Fields
    $content_type_field_links = Get-PnpProperty -ClientObject $content_type FieldLinks
    # TODO: Also export the actual content type itself so we can add custom content types to wherever we're importing this to

    [PSCustomObject]@{
        Name = $content_type.Name;
        ClientFormCustomFormatter=$content_type.ClientFormCustomFormatter;
    } | ConvertTo-Json  -Depth 10  > ".\$dir_name\ContentType_$($content_type.Name).json";
}

# INFO: Exporting the list's columns
[PSCustomObject]@{
    Columns=$Columns;
    Title=$pnplist.title;
} | ConvertTo-Json  -Depth 10  > ".\$dir_name\List.json";
