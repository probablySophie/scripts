-- Add a pagebreak

local function insert_pagebreak(el)
	-- We're a word doc
	if (FORMAT == "docx") then
		return pandoc.RawInline('openxml', string.format([[ <w:r> <w:br w:type="page"/> </w:r> ]]))
	elseif (FORMAT == "latex") then
		return pandoc.RawBlock("tex", "\\newpage{}")
	end
	return el
end

return {
	match = function(el)
		-- If HTML & matches <!-- page break --> or <!-- pagebreak -->
		if el.format == "html" and string.match(el.text, "%<%!%-%-%s*page%s*break%s*%-%-%>") then
			return true
		end
		return false
	end;
	parse = function(el)
		return insert_pagebreak(el)
	end;
}
