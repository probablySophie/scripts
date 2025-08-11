import { CardComponent } from "../card_builder";

interface TextBlockProps extends Record<string, any>
{
	wrap?: boolean,
	size?: "Small" | "Default" | "Medium" | "Large",
	weight?: "Lighter" | "Default" | "Bolder"
}

export function TextBlock(text: string, props?: TextBlockProps): CardComponent
{
	return {
		...props,
		type: "TextBlock",
		text,
	}
}

export function Badge(text: string, props?: { size?: string, style?: string }): CardComponent
{
	return {
		type: "Badge",
		text,
		size: props?.size? props.size : undefined,
		style: props?.style? props.style : undefined,
	}
}

export function ColumnSet(columns: {width?: string, items: CardComponent[], verticalContentAlignment?: string }[]): CardComponent
{
	return {
		type: "ColumnSet",
		columns: columns.map( col => ({
			type: "Column",
			width: col.width || "auto",
			items: col.items,
			verticalContentAlignment: col.verticalContentAlignment? col.verticalContentAlignment : undefined
		}) ),
	}
}

type TableColumn = number;
export function Table(rows: (CardComponent | CardComponent[])[], columns: TableColumn|TableColumn[]): CardComponent
{
	if ( !Array.isArray(columns) ) {
		let c: number[] = [];
		for ( let i = 0; i < columns; i++ ) { c.push(1) };
		columns = c;
	}
	return {
		type: "Table",
		columns: columns.map( c => ({ width: c }) ),
		rows: rows.map( row => {
			if ( !Array.isArray(row) ) { row = [row] }
			return {
			type: "TableRow",
			cells: row.map( cell => ({
					type: "TableCell",
					items: Array.isArray(cell)? cell : [cell]
				}) )
			
		}} )
	}
}

export function FactSet( props: {title: string, value: string}[] ): CardComponent
{
	return {
		type: "FactSet",
		facts: props
	}
}

interface ToggleVisibleProps
{
	iconUrl?: string
}

export function ToggleVisible(button_text: string, target_id: string | string[], props?: ToggleVisibleProps): CardComponent
{
	if ( !Array.isArray(target_id) ) { target_id = [ target_id ] }
	return {
		type: "ActionSet",
		actions: [
			{
				type: "Action.ToggleVisibility",
				title: button_text,
				iconUrl: props?.iconUrl? props.iconUrl : "icon:info",
				targetElements: target_id
			}
		]
	}
}
