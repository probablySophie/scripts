
-- sdtPr - structured document tag properties

local function new_tag(name, annotation, children)
	local Tag = {
		name = name or "";
		annotation = annotation or "";
		text = "";
		children = children or {};
	};
	function Tag.render(self)
		local contents = "";
		local annotation = self.annotation == "" and "" or " "..self.annotation;

		for _,v in pairs(self.children) do
			contents = contents .. v.render(v);
		end
		if contents == "" and self.text ~= "" then
			contents = self.text;
		end
		if contents == "" then
			return string.format([[<%s%s/>]],
				self.name,
				annotation);
		end
		-- Else
		return string.format([[<%s%s> %s </%s>]],
			self.name,
			annotation,
			contents,
			self.name);
	end
	return Tag
end

-- Add a word content control (text entry box)
local function word_contentcontrol(el)
	local tag = el.attributes['data-tag'] or "Field";
	local text = utils.stringify(el);

	local sdt_pr = new_tag("w:sdtPr", "", {
		new_tag("w:id", [[w:val="0"]]),
		new_tag("w:tag", string.format([[w:val="%s"]]), tag),
		new_tag("w:placeholder", "", { new_tag("w:docPart", [[w:val="DefaultPlaceholder"]]) }),
		new_tag("w:showingPlcHdr"),
		new_tag("w:text"),
	});

	local text_item = new_tag("w:t");
	text_item.text = text or "Click or tap here to enter text.";

	local sdt_content = new_tag("w:sdtContent", "", {
		new_tag("w:r", "", {
			new_tag("w:rPr", "", { new_tag("w:rStyle", [[w:val="PlaceholderText"]]) }),
			text_item,
		})
	});

	local base_tag = new_tag("w:sdt", "", {
		sdt_pr,
		sdt_content
	});

	local xml = base_tag.render(base_tag);

-- 	local xml = string.format([[<w:sdt>
-- 	<w:sdtPr>
-- 		<w:id w:val="0"/>
--     	<w:tag w:val="%s"/>
--     	<w:placeholder>
--       		<w:docPart w:val="DefaultPlaceholder"/>
--     	</w:placeholder>
--     	<w:showingPlcHdr/>
-- 		<w:text/>
--   	</w:sdtPr>
-- 	<w:sdtContent>
-- 		<w:r>
-- 			<w:rPr> <w:rStyle w:val="PlaceholderText"/> </w:rPr>
-- 			<w:t>%s</w:t>
-- 		</w:r>
-- 	</w:sdtContent>
-- </w:sdt>]], tag, text);

	return pandoc.RawInline('openxml', xml);
end

return {
	match = function(el)
		-- If its not word we don't care
		if FORMAT ~= "docx" then; return false; end
		if el.classes:includes('cc') then return true; end
		return false
	end;
	parse = function(el)
		if el.classes:includes('cc') then return word_contentcontrol(el); end
		return el
	end
}
