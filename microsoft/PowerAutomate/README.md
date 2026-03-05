# Power Automate Scripts & Bits

Getting the UTC start & end of a local-time day from a UTC timestamp:
```bash
# Start of day
convertToUtc(
	startOfDay( ${ TIMESTAMP_IN_LOCAL_TIME } ),
	'localtimezone/string'
)

# End of day
convertToUtc(
	addDays( startOfDay( ${ TIMESTAMP_IN_LOCAL_TIME } ), 1 ),
	'localtimezone/string'
)
```
