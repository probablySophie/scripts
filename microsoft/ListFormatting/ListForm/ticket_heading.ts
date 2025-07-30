export {}
import { Span, type Elm, contact, PersonCard, Icon } from "../columns";

let heading: Elm = {
	elmType: "div",
	attributes: { class: "ms-borderColor-neutralTertiary" },
	style: {
        "width": "99%",
        "border-width": "0px",
        "border-bottom-width": "1px",
        "border-style": "solid",
        "margin-bottom": "16px",
        "padding-bottom": "5px",
        "display": "flex",
        "flex-direction": "column",
        "align-items": "start"
	},
	children: []
}

let title: Elm = {
	elmType: "div",
    style: {
        "display": "flex",
        "box-sizing": "border-box",
        "align-items": "center"
    },
    children: [
    	Icon("Group", { attributes: { "class": "ms-fontWeight-regular ms-fontColor-themePrimary", title: "Details" } }, 42),
    	{
    		elmType: "div",
    		attributes: { class: "ms-fontColor-neutralSecondary ms-fontWeight-bold ms-fontSize-24" },
	        style: { "box-sizing": "border-box", "width": "100%", "text-align": "left", "padding": "21px 12px", "overflow": "hidden" },
	        children: [ Span("='#' + [$ID] + ' - ' + [$Title]") ]
    	}
    ]
}

function raised_by(field: string, display: string): Elm
{
	return {
		elmType: "div",
		style: { "display": display, "gap": ".5em", "align-items": "center" },
		children: [
			Span("Contact: ", { style: { "font-size": "110%" } }),
			PersonCard(field),
			contact.teams(`[$${field}.title]`, `[$${field}.email]`),
			contact.email(`[$${field}.title]`, `[$${field}.email]`, "[$ID] + ' - ' + [$Title]")
		]
	}
}



heading.children = [
	title,
	raised_by("Author", "=if(toString([$Contact]) == '', 'flex', 'none')"),
	raised_by("Contact", "=if(toString([$Contact]) == '', 'none', 'flex')"),
]
// @ts-ignore
await Bun.write("ticket_heading.json", JSON.stringify(heading))
