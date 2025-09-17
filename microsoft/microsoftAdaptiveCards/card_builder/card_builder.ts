import BadgeTitle from "./elements/badge_title"
import { FactSet, Table, TextBlock } from "./components";
import RuntimeInfo from "./elements/runtime_info"

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

// card.body = [
// 	BadgeTitle({
// 		badge_style: "@{variables('Card Info')?['button_style']}"
// 	}),


// 	RuntimeInfo()
// ]

// console.log(JSON.stringify(card));
