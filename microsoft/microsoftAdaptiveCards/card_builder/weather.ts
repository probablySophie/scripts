
import { FactSet, Table, TextBlock, ColumnSet } from "./components";

import { baseCard, type CardComponent } from "./card_builder";


// We're expecting an MSN Weather element with the name "Get forcast for today"
let weather_outputs = {
	conditions: "body/responses/daily/day/cap",
	rain_chance: "body/responses/daily/precip",

	temp_high: "body/responses/daily/tempHi",
	temp_low: "body/responses/daily/tempLo",
	temp_unit: "body/units/temperature",

	sunset_time: "body/responses/almanac/sunset",
	moon_phase: "body/responses/almanac/moonPhase",
	
	wind_speed: "body/responses/daily/day/windSpd",
	wind_speed_units: "body/units/speed",
}
let weather_output_elm = "Get_forecast_for_today"

Object.keys(weather_outputs).map( key => {
	weather_outputs[key] = `@{outputs('${weather_output_elm}')?['${weather_outputs[key]}']}`
} )

// I'm expecting a variable called "Sunset Time"
let sunset_time = "@{variables('Sunset Time')}";

let event_array_variable = "@{variables('Event Array')}";


// convertFromUtc(replace(outputs('Get_forecast_for_today')?['body/responses/almanac/sunset'], '+00:00', 'Z'), outputs('Flow_Info')?['timezone'], 'h:mm tt')

let weather_card = baseCard;

// Heading
weather_card.body.push(
	TextBlock( "Weather", { wrap: true, size: "Large", weight: "Bolder" } )
);

weather_card.body.push(
	TextBlock( `Skies ${weather_outputs.conditions} with a ${weather_outputs.rain_chance}% chance of rain`, { wrap: true, spacing: "None" } )
);

weather_card.body.push(
	Table(
		// Rows
		[
			// Row 1
			[
				// Cell 1
				[ TextBlock( `High: ${weather_outputs.temp_high}${weather_outputs.temp_unit}`, { spacing: "None" } ), TextBlock(`Low: ${weather_outputs.temp_low}${weather_outputs.temp_unit}`, { spacing: "None" }) ],
				// Cell 2
				[ TextBlock( `Max Windspeed: ${weather_outputs.wind_speed} ${weather_outputs.wind_speed_units}`, { wrap: true, spacing: "None" } ) ]
			]
		],
		[1, 1]
	)
);

weather_card.body.push(
	TextBlock( `Sunset will be at ${sunset_time} with the moon in ${weather_outputs.moon_phase}`, { wrap: true, spacing: "Small" } )
)

weather_card.body.push(
	TextBlock("Today's Events", { size: "Large", weight: "Bolder" })
)

weather_card.body.push(
	{
		type: "FactSet",
		facts: event_array_variable
	}
)

console.log( JSON.stringify(weather_card).replace(`"${event_array_variable}"`, `${event_array_variable}`) );
