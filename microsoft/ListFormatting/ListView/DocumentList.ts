export {}
import { Span, RowFormatter, icon_type_icon_url, Img, switch_val } from "../columns";


let base: RowFormatter = {
	"$schema": "https://developer.microsoft.com/json-schemas/sp/v2/row-formatting.schema.json",
	"hideSelection": true,
	"hideColumnHeader": true,
	rowFormatter: {
		elmType: "div",
		style: {
			"height": "fit-content",
			"margin-bottom": "5px",
			"cursor": "pointer"
		},
		customRowAction: { action: "defaultClick" },
		attributes: { class: "ms-fontColor-themePrimary--hover ms-bgColor-gray10--hover" },
		children: []
	},
}

base.rowFormatter.children?.push({
	elmType: "div",
	style: { width: "32px", height: "32px", "margin-right": "10px", "flex-shrink": "0" },
	children: [
		Img("='" + icon_type_icon_url( "' + " + switch_val(
	"[$File_x0020_Type]",
	[
		{ cmp_val: "'url'", result: "'link'" },
		{ cmp_val: "'doc'", result: "'docx'" },
	],
	`[$File_x0020_Type]`
) + " + '" ) + "'"),
	]
});

base.groupProps = {
	headerFormatter: {
		elmType: "div",
		txtContent: "=@group.fieldData + ' (' + @group.count + ')'"
	}
}

base.rowFormatter.children?.push(
	Span("=if([$Title] == '', [$FileLeafRef], [$Title])", {
		attributes: { class: "ms-fontSize-14" } }
	)
);

// @ts-ignore
await Bun.write("document_list.json", JSON.stringify(base))
