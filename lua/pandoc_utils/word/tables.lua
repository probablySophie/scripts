

local function requests_formatting(elm)
	local body_i = 1;
	-- For each body in the table
	while elm.bodies[body_i] ~= nil do
		local row_i = 1;
		-- For each row in the table body
		while elm.bodies[body_i].body[row_i] ~= nil do
			local wants_formatting = false;
			-- For each Inline elements in the row
			elm.bodies[body_i].body[row_i]:walk {
				RawInline = function(inline)
					-- If the row has a raw inline <!-- [...] --> that includes "format_row"
					if string.match(inline.text, "format_row") ~= nil then
						-- mark true
						wants_formatting = true;
					end
				end
			}
			-- if true - return true
			if wants_formatting then
				return true
			end
			row_i = row_i + 1;
		end
		body_i = body_i + 1;
	end
	-- If we got here - nothing wants doing
	return false
end


local function TableRow(elm)
	local formatting = false;
	local format_string = "";
	-- Does this table row have a raw inline with "format_row" in it?
	elm:walk {
		RawInline = function (elm)
			if string.match(elm.text, "format_row") ~= nil then
				formatting = true;
				format_string = elm.text;
			end
		end
	}
	-- If we're not formatting then we don't care :)
	if not formatting then return end

	-- Get the heading level (if there is one)
	-- e.g. <!-- table_row h2 -->
	local heading_level = string.match(format_string, "[^%w]h(%d)[^%w]");
	if heading_level ~= nil then
		local i = 1;
		while elm.cells[i] ~= nil do
			local contents = pandoc.utils.blocks_to_inlines(elm.cells[i].contents);

			elm.cells[i].contents = pandoc.List({pandoc.Header(heading_level, contents)});
			i = i + 1;
		end
	end
	return elm
end

local function TableBody(elm)
	local i = 1;
	local changed = false;
	while elm.body[i] ~= nil do
		local new_row = TableRow(elm.body[i]);
		if new_row ~= nil then
			elm.body[i] = new_row;
			changed = true;
		end
		i = i + 1;
	end
	if changed then
		return elm
	end
end

return {
	match = function(elm)
		if FORMAT ~= "DOCX" then return false end
		return requests_formatting(elm);
	end,
	parse = function(elm)
		local body_i = 1;
		-- For each body in the table
		local changed = false;
		while elm.bodies[body_i] ~= nil do
			local new_body = TableBody(elm.bodies[body_i]);
			if new_body ~= nil then
				elm.bodies[body_i] = new_body;
				changed = true;
			end
			body_i = body_i + 1;
		end
		if changed then
			return elm
		end
	end,
}
