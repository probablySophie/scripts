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

function ifs()
{
	
}

base.rowFormatter.children?.push({
	elmType: "div",
	style: { width: "32px", height: "32px", "margin-right": "10px", "flex-shrink": "0" },
	children: [
		Img("='" + icon_type_icon_url( "' + " + switch_val(
	"[$File_x0020_Type]",
	[
		{ cmp_val: "'url'", result: "'link'" },
		{ cmp_val: ["'mp4'"], result: "'video'" },
		{ cmp_val: ["'pdf'"], result: "'pdf'" },
		{ cmp_val: ["'txt'"], result: "'txt'" },
		// Spreadsheets
		{ cmp_val: ["xls", "xlsx", "xlb", "xlc", "xlsb", "xlsm", "xlt", "xltx", "xltm", "xlm", "xla", "xll", "xlam", "xlw", "excel", "csv", "odc", "ods"].map(t => `'${t}'`), result: "'xlsx'" },
		// Text Documents
		{ cmp_val: ["doc", "docx", "docm", "dot", "dotx", "dotm", "odt", "docb", "wbk", "rtf", "word"].map(t => `${t}`), result: "'docx'" },
		// Images
		{ cmp_val: ["bmp", "dib", "gif", "ico", "jfif", "jpe", "jpeg", "jpg", "png", "svg", "tif", "tiff", "xbm", "xpm"].map(t => `'${t}'`), result: "'photo'" },
		// Presentations
		{ cmp_val: ["pptx", "ppt", "pot", "potx", "potm", "ppam", "ppsx", "ppsm", "sldx", "sldm", "ppa", "pps", "pptm", "odp", "powerpoint"].map(t => `'${t}'`), result: "'pptx'" },
		// Pages
		{ cmp_val: ["htm", "html", "aspx", "css"].map(t => `'${t}'`), result: "'html'" },
	],
	`'genericfile'`
) + " + '" ) + "'", { style: { "padding": "2px" } } ),
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
