/**
 * @file Provides the Ascii-Group Seperated Value namespace, parsing to and from strings
 */

export namespace ASV {
	export const SEPARATOR = {
		FILE: String.fromCharCode(28),
		GROUP: String.fromCharCode(29),
		RECORD: String.fromCharCode(30),
		UNIT: String.fromCharCode(31),
	}
	export type Table = {
		meta: Record<string, string>,
		headings: {name: string, type?: string, decorator?: string}[],
		values: any[][],
	}
	export function toString(tables: Table[] | Table): string
	{
		// Make sure we're working with an array/list
		// I feel its nice UX if we take a single item as a valid argument
		if (!Array.isArray(tables)) { tables = [tables] };

		let return_string = "";

		const row_string = (items: string[]): string => {
			return items.join(SEPARATOR.UNIT) + SEPARATOR.UNIT + SEPARATOR.RECORD;
		}

		for (const table of tables)
		{
			// Meta Value Identifiers
			return_string += row_string(Object.keys(table.meta)) + "\n";
			// Meta Values
			return_string += row_string(Object.values(table.meta)) + "\n";
			// Column Headings
			return_string += row_string(table.headings.map(h => h.name)) + "\n";
			// Column Types
			// Are there actualy any column types?
			if ( table.headings.find( h => typeof h.type == "string" ) )
			{
				return_string += row_string(table.headings.map(
					h => typeof h.type == "string"? h.type : ""
				)) + "\n";

				// Are there decorators?
				if ( table.headings.find( h => typeof h.decorator == "string" ) )
				{
					return_string += row_string(table.headings.map(
						h => typeof h.decorator == "string"? h.decorator : ""
					)) + "\n";
				}
			}
			// Group seperator, the start of data!
			return_string += SEPARATOR.GROUP + "\n";

			const num_columns = table.headings.length;

			// For each data row
			for (const value_set of table.values)
			{
				const values: string[] = [];
				// For each data item
				for (const value of value_set)
				{
					switch (typeof value)
					{
						case "string":
							values.push(value);
							continue
						case "number":
						case "bigint":
						case "boolean":
							values.push(value.toString());
							continue
						case "undefined":
							values.push("");
							continue	
					}
					if (value == null)
					{
						values.push("");
						continue
					}
					if (typeof value == "object")
					{
						values.push( JSON.stringify(value) );
						continue
					}
					console.error(`Got unknown & unhandled variable\nType: ${typeof value}\nValue: `, value);
				}
				if (values.length < num_columns) {
					for (let i = 0; i < num_columns - values.length; i++)
					{
						values.push("")
					}
				}
				return_string += row_string(values) + "\n";
			}

			// End of table!
			return_string += SEPARATOR.FILE + "\n";
		}

		return return_string
	}

	export function parse(input: string): Table | Table[]
	{
		let tables: Table[] = [];
		const trim_newline = (s: string): string => {
			if (s.length == 0) {return s}
			return s[0] == '\n'? s.slice(1) : s;
		}
		const parse_group = (input: string): string[][] => {
			let v = trim_newline(input).split(SEPARATOR.RECORD).map(
				r => {
					let v = trim_newline(r).split(SEPARATOR.UNIT).map(trim_newline)
					if (v.length > 0) {
						if (v[v.length-1] == "") { v.pop() }
					}
					return v
				}
			);
			if ((v[v.length-1].length == 1 && v[v.length-1][0] == "")
			   || v[v.length-1].length == 0
			) { v.pop() }
			return v
		}

		input.split(SEPARATOR.FILE).forEach(
			table_string => {
				// trim newline
				table_string = trim_newline(table_string);
				if (table_string[0] == '\n') { table_string = table_string.slice(1) }

				let [meta, data] = table_string.split(SEPARATOR.GROUP);

				// If there aren't two sets of data, skip
				if (meta == null || data == null) { return }
				let meta_lines = parse_group(meta);
				let data_lines = parse_group(data);

				if (meta_lines.length < 3) { return }
				// Table Metadata
				let meta_items: Record<string, string> = {};

				if (meta_lines[0].length != meta_lines[1].length) { return }
				for (let i = 0; i < meta_lines[0].length; i++)
				{
					meta_items[ meta_lines[0][i] ] = meta_lines[1][i];
				}

				// Table Column Heading Names
				let headings: {
					name: string,
					type?: string,
					decorator?: string
				}[] = meta_lines[2].map( name => ({name: name}) );

				// Table Column Types (optional)
				if (meta_lines.length >= 4) {
					for (let i = 0; i < meta_lines[3].length; i++)
					{
						headings[i].type = meta_lines[3][i];
					}
				}

				// Table Column Heading Descriptors (optional, requires types)
				if (meta_lines.length >= 5) {
					for (let i = 0; i < meta_lines[4].length; i++)
					{
						headings[i].decorator = meta_lines[4][i];
					}
				}

				let values: any[][] = [];
				for (const line of data_lines)
				{
					let new_value: any[] = [];
					for (let i = 0; i < line.length; i++)
					{
						switch(headings[i].type)
						{
							case null: break;
							case "string":
								new_value.push(line[i])
								continue;
							case "number":
								new_value.push(Number(line[i]))
								continue;
							case "object":
								new_value.push(JSON.parse(line[i]))
								continue;
							case "boolean":
								new_value.push(line[i] == "true")
								continue;
						}
						// Else
						new_value.push( line[i] );
					}
					values.push(new_value);
				}

				tables.push({
					meta: meta_items,
					headings: headings,
					values: values
				});
			}
		)

		return (tables.length == 1)? tables[0] : tables;
	}

	/** Returns a string where the record separators have been replaced with readable versions
		e.g. Unit Separator -> [US]
	*/
	export function toDecoratedString(tables: Table | Table[]): string
	{
		return (ASV.toString(tables)
			.replaceAll(SEPARATOR.FILE, "[FS]")
			.replaceAll(SEPARATOR.GROUP, "[GS]")
			.replaceAll(SEPARATOR.RECORD, "[RS]")
			.replaceAll(SEPARATOR.UNIT, "[US]")
		);
	}
}

const myTable: ASV.Table = {
	meta: { "Name": "Animals" },
	headings: [
		{name: "Id", type: "number"},
		{name: "Name", type: "string"},
		{name: "Species", type: "string"}
	],
	values: [
		[ 1, "Beetlejuice", "Cat" ],
		[ 2, "Indominus", "Lizard" ]
	]
}
const table_string = ASV.toString(myTable);
const myTable2 = ASV.parse(table_string);

console.log(myTable);
console.log(myTable2);

