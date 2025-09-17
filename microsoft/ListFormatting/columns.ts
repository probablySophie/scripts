
export interface Action
{
	action: "defaultClick" | "executeFlow" | "share" | "delete" | "editProps" | "openContextMenu" | "setValue" | "embed",
	actionParams?: string,
	actionInput?: Record<string, string>
}

export type ElmType = "div" | "span" | "a" | "img" | "svg" | "path" | "button" | "p" | "filepreview"
export type Attribute = "href" | "rel" | "src" | "class" | "target" | "title" | "role" | "iconName" | "d" | "aria" | "data-interception" | "viewBox" | "preserveAspectRatio" | "draggable"

export interface Attributes
{
	href?: string,
	rel?: string,
	src?: string,
	/** https://zerg00s.github.io/sp-modern-classes/ */
	class?: string,
	target?: string,
	title?: string,
	role?: string,
	/** FluentUI Icons https://developer.microsoft.com/en-us/fluentui#/styles/web/icons#available-icons */
	iconName?: string,
	d?: string,
	aria?: string,
	"data-interception"?: string,
	viewBox?: string,
	preserveAspectRatio?: string,
	draggable?: string,
}

export type Styles = Record<string, string>;

export interface Elm
{
	"$schema"?: "https://developer.microsoft.com/json-schemas/sp/v2/column-formatting.schema.json",
	elmType: string
	txtContent?: string
	style?: Styles
	attributes?: Attributes,
	children?: Elm[],
	// https://learn.microsoft.com/en-us/sharepoint/dev/declarative-customization/formatting-syntax-reference#foreach
	forEach?: string
	// Must be a button
	customRowAction?: Action,
	customCardProps?: {
		formatter: Elm
		openOnEvent: "click" | "hover",
		directionalHint?: "bottomAutoEdge" | "bottomCenter" | "bottomLeftEdge" | "bottomRightEdge" | "leftBottomEdge" | "leftCenter" | "leftTopEdge" | "rightBottomEdge" | "rightCenter" | "rightTopEdge" | "topAutoEdge" | "topCenter" | "topLeftEdge" | "topRightEdge",
		isBeakVisible?: boolean
		beakStyle?: Record<string, string>
	}
	defaultHoverField?: string
	columnFormatterReference?: string
	inlineEditField?: string
	filePreviewProps?: {
		fileTypeIconClass?: string,
		fileTypeIconStyle?: Record<string, string>,
		brandTypeIconClass?: string,
		brandTypeIconStyle?: Record<string, string>
	}
}


export interface CommandBar {
	"$schema": "https://developer.microsoft.com/json-schemas/sp/v2/command-bar-formatting.schema.json",
	commands: {
		key: string,
		hide?: boolean,
		position?: number
		primary?: boolean,
		text?: string
		iconName?: string,
		title?: string,
		selectionType?: "Primary" | "Overflow",
		selectionModes?: ("NoSelection" | "SingleSelection" | "MultiSelection")[]
	}[]
	
}


interface ElmProps {
	style?: Styles,
	attributes?: Attributes
}

export function Span(text: string, props?: ElmProps): Elm
{
	return {
		elmType: "span",
		txtContent: text,
		...props
	}
}
export function Icon(icon_name: string, props?: ElmProps, size?: number): Elm
{
	props = props || {};
	props.attributes = props.attributes || {};
	props.attributes.iconName = icon_name;

	if ( size != null ) {
		let class_name = `ms-fontSize-${size}`;
		if ( props.attributes.class == null ) { // If class is null then we can just set it :)
			props.attributes.class = class_name;
		} else if ( props.attributes.class.indexOf("fontSize") == -1 ) { // if we're not already setting a font size 
			props.attributes.class += ` ${class_name}`;
		}
	}
	
	return {
		elmType: "span",
		...props
	}
}
export function Link(children: Elm[] | Elm, href: string, props?: ElmProps): Elm
{
	if ( ! ( Array.isArray(children) ) ) { children = [children] }

	if ( props == null ) { props = {} }
	if ( props.attributes == null ) { props.attributes = {} }
	props.attributes.href = href;
	props.attributes.target = props.attributes.target || "_blank";

	return {
		elmType: "a",
		children: children,
		...props
	}
}


export namespace contact
{
	export function teams(name: string, email: string, props?: ElmProps): Elm
	{
		return Link([
			Icon("TeamsLogo", {
				attributes: {
					class: "ms-fontSize-20 ms-fontWeight-regular ms-fontColor-themePrimary",
					title: `='Message ' + ${name} + ' on Teams'`
				}
			})
		], `='https://teams.microsoft.com/l/chat/0/0?users=' + ${email}`, props)
	}
	export function email(name: string, email: string, subject?: string, props?: ElmProps): Elm
	{
		return Link([
			Icon("OutlookLogo", {
				attributes: {
					class: "ms-fontSize-20 ms-fontWeight-regular ms-fontColor-themePrimary",
					title: `='Send ' + ${name} + ' an email'`
				}
			})
		], `='mailto:' + ${email} + ${ subject? `'?subject=' + ${subject}` : "" }`, props)
	}
}

export function PersonCard(person_field_name: string): Elm
{
	return {
		elmType: "div",
		defaultHoverField: `[$${person_field_name}]`,
		attributes: { class: "ms-bgColor-neutralLight ms-fontColor-neutralPrimary" },
		style: {
	        "display": "flex",
	        "align-items": "center",
	        "gap": "5px",
	        "border-radius": "2em"
		},
		children: [
			{ elmType: "img", attributes: { src: `=getUserImage([$${person_field_name}.email], 'small')`, title: `[$${person_field_name}.title]` }, style: { "border-radius": "2em", "width": "2em" } },
			Span(`[$${person_field_name}.title]`),
			Span("")
		]
	}
}

/*
{
    "elmType": "div",
    "defaultHoverField": "[$Author]",
    "attributes": { "class": "" },
    "style": {
        "display": "flex",
        "align-items": "center",
        "gap": "5px",
        "border-radius": "2em"
    },
    "children": [
        {
            "elmType": "img",
            "attributes": {
                "src": "=getUserImage([$Author.email], 'small')",
                "title": "[$Author.title]"
            },
            "style": {
                "border-radius": "2em",
                "width": "2em"
            }
        },
        { "elmType": "span", "txtContent": "[$Author.title]" },
        { "elmType": "span", "txtContent": "" }
    ]
},

*/

export interface RowFormatter {
	"$schema": "https://developer.microsoft.com/json-schemas/sp/v2/row-formatting.schema.json",
	hideSelection?: boolean,
	hideColumnHeader?: boolean,
	rowFormatter: Elm,
    additionalRowClass?: "",
    groupProps?: {
    	headerFormatter?: Elm,
    	hideFooter?: boolean,
    	footerFormatter?: Elm
    }
    hideFooter?: boolean
    footerFormatter?: Elm
    commandBarProps?: CommandBar
}


export function FilePreview( preview_size: "small" | "medium" | "large", props?: ElmProps & {
	/** The file preview */
	file_icon_class?: string,
	file_icon_style?: Record<string, string>,
	/** The little *word* or *powerpoint* icon on the preview */
	brand_icon_class?: string,
	brand_icon_style?: Record<string, string>,
} ): Elm
{	
	return {
		elmType: "filepreview",
		style: props?.style,
		attributes: { ...props?.attributes, src: `@thumbnail.${preview_size}` },
		filePreviewProps: {
			fileTypeIconClass: props?.file_icon_class,
			fileTypeIconStyle: props?.file_icon_style,
			brandTypeIconClass: props?.brand_icon_class,
			brandTypeIconStyle: props?.brand_icon_style
		}
	}
}

export function FileIcon(classes?: string, style?: Record<string, string>): Elm
{
	return {
		elmType: "filepreview",
		attributes: { src: "@32" },
		filePreviewProps: {}
	}
}

/** Querying file_type icons directly from Microsoft's CDNs */
export function icon_type_icon_url(icon_name: string): string
{
	return `https://res-1.cdn.office.net/files/fabric/assets/item-types/24/${icon_name}.svg`;
	// return `https://spoprod-a.akamaihd.net/files/fabric/assets/item-types/40/${icon_name}.svg`
}

/** Make an image element */
export function Img(source: string, props?: ElmProps): Elm
{
	let elm: Elm = {
		elmType: "img",
		...props,
	}
	if ( elm.attributes == null ) { elm.attributes = {} };
	elm.attributes.src = source;

	return elm
}


export function switch_val(switch_var: string, options: {cmp_val: string | string[], result: string, cmp_method?: "eq" | "startsWith"}[], default_val: string): string
{
	let str = ``
	let eof_str = "";

	for ( const prop of options ) {
		if ( ! Array.isArray( prop.cmp_val ) ) {
			prop.cmp_val = [ prop.cmp_val ]
		}
		for ( const val of prop.cmp_val )
		{
			str += `if(`
			switch( prop.cmp_method )
			{
				case "eq":
				case null:
				default:
					str += `${switch_var} == ${val}`
					break;
				case "startsWith":
					str += `startsWith(${switch_var}, ${val})`
					break;
			}
			str += `, ${prop.result}, `
			eof_str += ")";
		}
	}

	return `${str}${default_val} ${eof_str}`
}
