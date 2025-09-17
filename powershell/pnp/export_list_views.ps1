
$views = Get-PnPView -List $pnplist
$Columns = Get-PnPField -List $pnplist | % { [PSCustomObject]@{ DisplayName=$_.Title; InternalName = $_.InternalName; CustomFormatter=$_.CustomFormatter; Type= $_.TypeAsString; Required = $_.Required; Choices=$_.Choices; DefaultValue=$_.DefaultValue; Description=$_.Description } }

$dir_name = "List_$($pnplist.title)";

$content_types = Get-PnPProperty -ClientObject $pnplist ContentTypes

# If the directory doesn't exist - make it
if ( (Get-Item ".\$dir_name" -ErrorAction SilentlyContinue) -eq $null )
{
    New-Item -Name $dir_name -ItemType Directory
}

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

foreach ($content_type in $content_types)
{
    $content_type_fields = Get-PnpProperty -ClientObject $content_type Fields
    $content_type_field_links = Get-PnpProperty -ClientObject $content_type FieldLinks

    [PSCustomObject]@{
        Name = $content_type.Name;
        ClientFormCustomFormatter=$content_type.ClientFormCustomFormatter;
    } | ConvertTo-Json  -Depth 10  > ".\$dir_name\ContentType_$($content_type.Name).json";
}

[PSCustomObject]@{
    Columns=$Columns;
    Title=$pnplist.title;
} | ConvertTo-Json  -Depth 10  > ".\$dir_name\List.json";
