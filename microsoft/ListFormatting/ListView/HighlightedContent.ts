export {}
import { Span, type Elm, type CommandBar, contact, PersonCard, Icon, RowFormatter } from "../columns";



let base: RowFormatter = {
	"$schema": "https://developer.microsoft.com/json-schemas/sp/v2/row-formatting.schema.json",
	"hideSelection": true,
	"hideColumnHeader": true,
	rowFormatter: {
		elmType: "div",
		style: {
			// "min-height": "100px",
			"height": "fit-content",
			"margin-bottom": "20px",
			"cursor": "pointer"
		},
		customRowAction: { action: "defaultClick" },
		attributes: { class: "ms-fontColor-black--hover sp-row-card" },
		children: []
	}
}

// INFO: The File Preview Thumbnail
base.rowFormatter.children?.push({
	elmType: "filepreview",
	attributes: { "src": "@thumbnail.medium" },
	// INFO: Do not display if this item is a URL
	style: { "height": "99px", "max-width": "177px", display: "=if([$File_x0020_Type] == 'url', 'none', 'block')" },
	filePreviewProps: {
		fileTypeIconStyle: { "display": "show" },
		brandTypeIconStyle: { "display": "none" }
	}
});
base.rowFormatter?.children?.push({
	elmType: "div",
	style: {
		display: "=if([$File_x0020_Type] == 'url', 'block', 'none')",
		"font-size": "20px",
		"padding-right": "7px",
	},
	attributes: {
		iconName: "Link12"
	}
})
// if([$File_x0020_Type] == 'url')

// INFO: The text/info container
let text_container: Elm = {
	elmType: "div",
	style: { "display": "flex", "flex-direction": "column", "justify-content":
                    "space-between", "height": "100%" },
	children: [],
}

// INFO: The title
text_container.children?.push({
	elmType: "div",
	style: { padding: "=if([$File_x0020_Type] == 'url', '0px', '7px')" },
	children: [ Span( "[$Title]", { attributes: { class: "ms-fontSize-20 ms-fontWeight-regular" } } ) ]
});

// INFO: The editor info
text_container.children?.push({
	elmType: "div",
	style: { display: "=if([$File_x0020_Type] == 'url', 'none', 'block')", padding: "7px" },
	children: [
		Span( "[$Editor.title]", { style: { "font-weight": "bold", "padding-right": "5px" } } ),
		Span( "='Edited ' + toLocaleDateString([$Modified])" )
	]
});

// INFO: The Shortcut URL if relevant
text_container.children?.push({
	elmType: "div",
	style: { display: "=if([$File_x0020_Type] == 'url', 'block', 'none')" },
	children: [
		Span( "[$_ShortcutUrl]" )
	]
});

base.rowFormatter.children?.push(text_container);

// @ts-ignore
await Bun.write("highlighted_content.json", JSON.stringify(base))
