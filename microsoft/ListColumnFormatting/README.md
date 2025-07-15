
# List Column Formatting


Formatting SharePoint List Columns

[Promoted State](./Promoted_State.json), makes the *Site Pages* document library's `Promoted State` column human readable (Site Page, Unpublished News, Published News vs. 0, 1, 2).



### Checking Variables

This will set the column's text to whatever you choose :)
```json
{
  "$schema": "https://developer.microsoft.com/json-schemas/sp/v2/column-formatting.schema.json",
  "elmType": "span",
  "txtContent": "=len(@currentField)"
}
```

### Snippets

ID + Title: '23 - Make a new site'
`"=[$ID] + ' - ' + [$Title]"`

### Documentation

* [PnP List Formatting Samples](https://pnp.github.io/List-Formatting/)  

Microsoft Learn
* [List Formatting Syntax Reference](https://learn.microsoft.com/en-us/sharepoint/dev/declarative-customization/formatting-syntax-reference)  
* [Column Formatting](https://learn.microsoft.com/en-us/sharepoint/dev/declarative-customization/column-formatting)  

