
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
	class?: string,
	target?: string,
	title?: string,
	role?: string,
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
