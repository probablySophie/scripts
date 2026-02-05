export {}
import { Span, RowFormatter, Img, Flex } from "../columns";

let base: RowFormatter = {
	"$schema": "https://developer.microsoft.com/json-schemas/sp/v2/row-formatting.schema.json",
	"hideSelection": true,
	"hideColumnHeader": true,
	rowFormatter: {
		elmType: "div",
		// Main elm is a column
		style: { margin: "5px", display: "flex", "flex-direction": "column" },
		attributes: { class: "sp-row-card" },
		children: [
			// Spaced between-row, title --- subtitle/tag
			Flex([
				Span("[$Title]", { attributes: { class: "ms-fontSize-20 ms-fontWeight-semibold" } }),
				Span("[$Subtitle]", { attributes: { class: "ms-fontSize-16 ms-fontColor-gray130" } }),
			], "row", {
					style: { width: "100%", "justify-content": "space-between", }
				}),
			// Row
			Flex([
				// Column 1 - image
				Img("=getThumbnailImage([$Image], 100, 100)", {
					style: {
						"border-radius": "100%",
						"max-width": "100px",
						"max-height": "100px",
					}
				}),
				// Column 2 - text
				Flex([
					Span("[$Description]", { attributes: { class: "ms-fontSize-16" } }),
				], "column")
			], "row", {
				style: { "gap": "15px" },
			})
		]
	}

}

// [$myImage.serverRelativeUrl]
// @ts-ignore
await Bun.write("image_card.json", JSON.stringify(base))
