
# Lua Scripts

## Pandoc

A Pandoc lua filter!

It filters:

|Filter|Example Inputs|Language(s)|
|-|-|
|`<!-- page break -->`|Inserts a page break|`DOCX` `latex`|
|`[optional placeholder text]{.cc data-tag="your_tag"}`|Inserts a Word text entry content-control|`DOCX`|


```lua

-- https://pandoc.org/lua-filters.html#pandoc.utils.type
pandoc.utils.type(elm) --> The element's pandoc type

-- Fetch a local or external file
local diagram_url = 'https://pandoc.org/diagram.jpg'
local mimetype, contents = pandoc.mediabag.fetch(diagram_url)
```

### Pandoc Globals


FORMAT - the document format (`html5`, `latex`, `docx`)

```json
"pandoc_element": {
	"text": "The element's text content"
}
```

### Examples

[Replacing Placeholders with Metadata Values](https://pandoc.org/lua-filters.html#replacing-placeholders-with-their-metadata-value)  
`%date%` -> `2000-01-01`
