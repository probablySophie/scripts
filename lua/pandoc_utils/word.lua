
-- sdtPr - structured document tag properties

function word_property_kv(key, value)
	if type(value) ~= "table" then
		local value = value or "";
		if value ~= "" then value = string.format([[ w:val="%s"]], value) end
		return string.format([[<w:%s%s/>]], key, value)
	end
	local extra_props = "";
	for k,v in pairs(value) do
		extra_props = extra_props .. word_property_kv(k, v);
	end
	return string.format([[<w:%s> %s </w:%s>]], key, extra_props, key);
end

-- sdt - structured document tag
function word_sdt(content_string, properties)
	local properties_string = "";
	-- If we were given properties...
	if properties ~= nil then
		-- ...for each property...
		for k,v in pairs(properties) do
			-- ...add it's key/value pair to our properties string...
			properties_string = properties_string..word_property_kv(k,v);
		end
		-- ...then wrap the properties string in the `structured document tag properties` xml tags
		properties_string = string.format([[<w:sdtPr> %s </w:sdtPr>]], properties_string);
	end

	return string.format([[<w:sdt> %s <w:sdtContent> %s </w:sdtContent> </w:sdt>]], properties_string, content_string)
end
-- Add a word content control (text entry box)
function word_contentcontrol(el)  
	local tag = el.attributes['data-tag'] or "Field";
	local text = utils.stringify(el);
	if text == "" then text = "Click or tap here to enter text."; end

	local xml = word_sdt([[<w:r> <w:rPr> <w:rStyle w:val="PlaceholderText"/> </w:rPr> <w:t> ]]..text..[[ </w:t> </w:r>]], {
		id = "0";
		tag = tag;
		placeholder = { docPart = "DefaultPlaceholder" };
		showingPlcHdr = "";
		text = ""
	});
	print(xml);
	return pandoc.RawInline('openxml', xml);
end
