-- Simple pandoc formatting :)

local utils = require 'pandoc.utils'

-- Contitionally replace raw blocks
function RawBlock(el)
	-- If HTML & matches <!-- page break --> or <!-- pagebreak -->
	if el.format == "html" and string.match(el.text, "%<%!%-%-%s*page%s*break%s*%-%-%>") then
		return pagebreak(el);
	end
	return el;
end

-- Conditionally replace text spans
function Span(el)
  -- data-tag is for later on so you can programatically pull the entered text
  -- [Enter your name here]{.cc data-tag="Person Name"}
  -- []{.cc data-tag="Content-Answer"}
	if el.classes:includes('cc') and FORMAT == "docx" then
		return word_contentcontrol(el);
	end
end




-- Add a word content control (text entry box)
function word_contentcontrol(el)  
	local tag = el.attributes['data-tag'] or "Field";
	local text = utils.stringify(el);
	if text == "" then text = "Click or tap here to enter text."; end

	local xml = string.format([[<w:sdt>
	<w:sdtPr>
		<w:id w:val="0"/>
    	<w:tag w:val="%s"/>
    	<w:placeholder>
      		<w:docPart w:val="DefaultPlaceholder"/>
    	</w:placeholder>
    	<w:showingPlcHdr/>
		<w:text/>
  	</w:sdtPr>
	<w:sdtContent>
		<w:r>
			<w:rPr> <w:rStyle w:val="PlaceholderText"/> </w:rPr>
			<w:t>%s</w:t>
		</w:r>
	</w:sdtContent>
</w:sdt>]], tag, text);

	return pandoc.RawInline('openxml', xml);
end

-- Add a pagebreak
function pagebreak(el)
	-- We're a word doc
	if (FORMAT == "docx") then
		return pandoc.RawInline('openxml', string.format([[ <w:r> <w:br w:type="page"/> </w:r> ]]))
	elseif (FORMAT == "latex") then
		return pandoc.RawBlock("tex", "\\newpage{}")
	end
	return el
end
