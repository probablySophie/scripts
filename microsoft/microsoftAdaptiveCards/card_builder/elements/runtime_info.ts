import { CardComponent } from "../card_builder"
import { TextBlock, ColumnSet } from "./component_functions"

interface RuntimeInfoProps
{
	run_start?: string,
	timezone?: string
}
const defaultProps: RuntimeInfoProps = {
	run_start: "outputs('Flow_Info')?['time/runStart']",
	timezone: "outputs('Flow_Info')?['timezone']"
}

export default function RuntimeInfo(props?: RuntimeInfoProps): CardComponent
{
	props = props? props : defaultProps;
	Object.keys(defaultProps).forEach( key => {
		if ( props[key] == null ) {
			props[key] = defaultProps[key];
		}
	} )
	return {
		type: "Container",
		id: "RuntimeInfo",
		items: [
			ColumnSet( [
				{ width: "stretch", items: [
					TextBlock( `Flow Started: @{convertFromUtc(${props.run_start}, ${props.timezone}, 'h:mm tt')}`, { wrap: true, size: "Small" } )
				] },
				{ width: "stretch", items: [
					TextBlock(`Last Updated: @{convertFromUtc(utcNow(), ${props.timezone}, 'h:mm tt')}`, { wrap: true, size: "Small" })
				] },
				{ width: "stretch", items: [
					// @{formatDateTime(
					// 	dateDifference(
					// 		convertFromUtc(outputs('Flow_Info')?['time/runstart'], utcNow()
					// 		), 'HH:mm:ss'
					// )}
					TextBlock(`Runtime: @{formatDateTime(dateDifference(${props.run_start}, utcNow()), 'HH:mm:ss')}`, { wrap: true, size: "Small" })
				] },
			] )
		]
	}
}
