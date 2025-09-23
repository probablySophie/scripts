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

const file_type_mappings: Record<string, string[]> = {
	"": ["folder"],
	"link": ["url", "link"],
	"video": ["mp4"],
	"pdf": ["pdf"],
	"txt": ["txt"],
	"zip": ["zip"],
	"spo": ["aspx"],
	"xlsx": ["xls", "xlsx", "xlb", "xlc", "xlsb", "xlsm", "xlm", "xla", "xll", "xlam", "xlw", "excel", "csv", "odc", "ods"],
	"xltx": ["xlt", "xltx", "xltm"],
	"docx": ["doc", "docx", "docm", "odt", "docb", "wbk", "rtf", "word"],
	"dotx": ["dot", "dotx", "dotm"],
	"photo": ["bmp", "dib", "gif", "ico", "jfif", "jpe", "jpeg", "jpg", "png", "svg", "tif", "tiff", "xbm", "xpm"],
	"pptx": ["pptx", "ppt", "ppam", "ppsx", "ppsm", "sldx", "sldm", "ppa", "pps", "pptm", "odp", "powerpoint"],
	"potx": ["pot", "potx", "potm"],
	"html": ["htm", "html", "css"],
	"email": ['eml', 'msg', 'oft', 'ost', 'pst']
}

// https://github.com/microsoft/fluentui/blob/master/packages/react-file-type-icons/src/FileTypeIconMap.ts
base.rowFormatter.children?.push({
	elmType: "div",
	style: { width: "32px", height: "32px", "margin-right": "10px", "flex-shrink": "0" },
	children: [
		Img("='" + icon_type_icon_url( "' + " + switch_val(
	"[$File_x0020_Type]",
	Object.keys(file_type_mappings).map( key => {
		return { result: `'${key}'`, cmp_val: file_type_mappings[key].map( s => `'${s}'` ) }
	} ),
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
