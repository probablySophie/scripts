# Get Calendar Events

This expects a Compose containing the contents of `./Compose/flow_info.json` with the timezone value populated appropriately.

It creates a string array containing a set of title/value "facts" that can be used in a `FactSet` element array inside an [adaptive card](https://adaptivecards.microsoft.com/).


****

A string array to hold the events
```json
{
	"type": "InitializeVariable",
	"inputs": {
		"variables": [
			{
				"name": "Event String Array",
				"type": "array"
			}
		]
	},
}
```

An *Office 365 Users* > *Send an HTTP Request* MS Graph request 
```json
{
	"type": "OpenApiConnection",
	"inputs": {
		"parameters": {
			"Uri": "https://graph.microsoft.com/v1.0/me/calendarview?startdatetime=@{convertToUtc(\r\n\tstartOfDay(\r\n\t\tconvertFromUtc(\r\n\t\t\toutputs('Flow_Info')['time/triggered'],\r\n\t\t\toutputs('Flow_Info')['timezone']\r\n\t\t)\r\n\t),\r\n  outputs('Flow_Info')['timezone']\r\n)}&enddatetime=@{convertToUtc(\n\taddDays(\n\t\tstartOfDay(\n\t\t\tconvertFromUtc(\n\t\t\t\toutputs('Flow_Info')['time/triggered'],\n\t\t\t\toutputs('Flow_Info')['timezone']\n\t\t\t)\n\t\t),\n\t\t1\n\t),\n\toutputs('Flow_Info')['timezone']\n)}",
			"Method": "GET",
			"ContentType": "application/json"
		},
	}
}
```

For each `body('that graph request above')?['value']`

Compose "Event Info"
```json
{
	"link": "@{item()?['webLink']}",
	"location": "@{if(item()?['isOnlineMeeting'], 'online', item()?['location/displayName'])}",
	"start": "@{convertTimeZone( item()?['start/dateTime'], item()?['start/timeZone'], outputs('Flow_Info')?['timezone'] )}",
	"length": "@{dateDifference(item()?['start/dateTime'], item()?['end/dateTime'])}"
}	
```

Compose "Extract Timespan"
```json
{
	"days": @{if ( equals(
	length(split(outputs('Event_Info')?['length'], '.')), 1 ), 0, int(split(outputs('Event_Info')?['length'], '.')[0]) ) },
	"hours": @{int(split(last(split(outputs('Event_Info')?['length'], '.')), ':')[0])},
	"minutes": @{int(split(last(split(outputs('Event_Info')?['length'], '.')), ':')[1])}
}
```

Append to Array (the string array from above)
```json
{
  "title": "@{formatDateTime(outputs('Event_Info')?['start'], 'hh:mm tt')}",
  "value": "[@{item()?['subject']}](@{outputs('Event_Info')?['link']}) (@{outputs('Event_Info')?['location']}) (`@{if(
	less( add(mul(add(mul(outputs('Extract_Timespan')?['days'], 24), outputs('Extract_Timespan')?['hours']), 60), outputs('Extract_Timespan')?['minutes']), 120 ),
	concat( add(mul(add(mul(outputs('Extract_Timespan')?['days'], 24), outputs('Extract_Timespan')?['hours']), 60), outputs('Extract_Timespan')?['minutes']), ' mins' ),
	if(
		less( add(
			mul(outputs('Extract_Timespan')?['days'], 24), outputs('Extract_Timespan')?['hours']), 24),
		concat( add(mul(outputs('Extract_Timespan')?['days'], 24), outputs('Extract_Timespan')?['hours']), ' hours' ),
		concat( outputs('Extract_Timespan')?['days'], 'days' )
	)
)}`)"
}	
```
