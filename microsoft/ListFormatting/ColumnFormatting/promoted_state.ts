
import { type Elm, Span } from "../columns";

let promoted_state: Elm = {
	elmType: "div",
	children: []
}
let states = [
	{ field_num: 0, text: "Site Page" },
	{ field_num: 1, text: "Unpublished News" },
	{ field_num: 2, text: "Published News" },
	{ field_num: '', text: "N/A" },
];
states.forEach( state => {
	promoted_state.children!.push(
		Span(state.text, { style: { display: `=if(@currentField == ${state.field_num}, 'block', 'none')` } }),
	)
});

// @ts-ignore
await Bun.write("PromotedState.json", JSON.stringify(promoted_state));
