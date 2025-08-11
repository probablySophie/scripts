import BadgeTitle from "./ts_elements/badge_title"
import { FactSet, Table, TextBlock } from "./ts_elements/component_functions";
import RuntimeInfo from "./ts_elements/runtime_info"

export const baseCard: { type: string, "$schema": string, version: string, body: CardComponent[] } = {
	type: "AdaptiveCard",
	"$schema": "https://adaptivecards.io/schemas/adaptive-card.json",
	version: "1.5",
	body: []
}
export interface CardComponent extends Record<string, any>
{
	type: string,
	id?: string,
	isVisible?: boolean,
	items?: CardComponent[] | string
}

let card = baseCard;

// Num attachments
// Num Marc
// Num Not-marc

card.body = [
	BadgeTitle({
		badge_style: "@{variables('Card Info')?['button_style']}"
	}),

	FactSet( [	
		{ title: "Num Attachments", value: "7" },
		{ title: "Num MRC", value: "3" },
		{ title: "Num Other", value: "4" },
	] ),

	RuntimeInfo()
]

// console.log(JSON.stringify(card));
