
import { type CardComponent } from "../card_builder";
import {  Badge, ColumnSet, TextBlock } from "../components";

interface BadgeTitleProps
{
	badge_text?: string,
	flow_name?: string,
	flow_link?: string,
	badge_style?: string,
	badge_size?: string
}
const defaultProps: BadgeTitleProps = {
	badge_text : "@{variables('Card Info')?['button_text']}",
	flow_name : "outputs('Flow_Info')?['displayName']",
	flow_link : "outputs('Flow_Info')?['links']['flow']",
	badge_style: "Accent",
	badge_size: "Large",
}

export default function  BadgeTitle( props?: BadgeTitleProps ): CardComponent
{
	if ( props != null ) {
		Object.keys(defaultProps).forEach( key => {
			if (props![key] == null) {
				props![key] = defaultProps[key];
			}
		} )
	} else { props = defaultProps }

	return {
		type: "Container",
		id: "TitleBardContainer",
		items: [
			ColumnSet( [
				{ items: [
                        Badge(`${props.badge_text}`, { size: props.badge_size, style: props.badge_style }),
				], verticalContentAlignment: "Center" },
				{
					width: "stretch",
					items: [
						TextBlock(`[@{${props.flow_name}}](@{${props.flow_link}})`, {
							wrap: true,
							size: "Large",
							weight: "Bolder"
						})
					], verticalContentAlignment: "Center" 
				}
			] )
		]
	}	
}
