-- Simple pandoc formatting :)

-- Get the current file path
local current_file = debug.getinfo(1, "S").short_src;
-- Get the file's directory path
local path = string.match(current_file, ".*/") or "";
-- If we're somewhere weird, append the directory's path onto lua's package search path
if path ~= "" then
	package.path = package.path .. ";" .. path .. "?.lua"
end

local utils = require 'pandoc.utils'

-- Adds a pagebreak if it finds `<!-- pagebreak -->`
-- local page_break = require ( path .. "pandoc_utils/pagebreak.lua" );
local page_break = require ( "pandoc_utils.pagebreak" );
local word_tables = require( "pandoc_utils.word.tables" );



-- Receives EVERY pandoc Block
-- https://pandoc.org/lua-filters.html#type-blocks
-- If Plain [ whtever] then its just an inline
-- function Block(elm)
-- 	print (elm);
-- end



function Table(elm)
	-- print(elm.caption);
	if word_tables.match(elm) then
		return word_tables.parse(elm);
	end
end


-- https://pandoc.org/lua-filters.html#type-blockquote
-- function BlockQuote(elm) end
-- https://pandoc.org/lua-filters.html#type-bulletlist
-- function BulletList(elm) end
-- https://pandoc.org/lua-filters.html#type-orderedlist
-- function OrderedList(elm) end
-- https://pandoc.org/lua-filters.html#type-codeblock
-- function CodeBlock(elm) end
-- https://pandoc.org/lua-filters.html#type-header
-- function Header(elm) end
-- https://pandoc.org/lua-filters.html#type-para
-- Paragraph
-- function Para(elm) end
-- https://pandoc.org/lua-filters.html#type-plain
-- Plain Text
-- function Plain(elm) end
-- https://pandoc.org/lua-filters.html#type-table
-- function Table(elm) end

-- https://pandoc.org/lua-filters.html#type-rawblock
-- Conditionally replace raw blocks
function RawBlock(el)
	if page_break.match(el) then
		return page_break.parse(el);
	end
end


-- Received EVERY pandoc Inline
-- https://pandoc.org/lua-filters.html#type-inlines
-- function Inline(elm)
-- 	-- print (elm);
-- end

-- https://pandoc.org/lua-filters.html#type-code
-- function Code(elm) end
-- https://pandoc.org/lua-filters.html#type-image
-- function Image(elm) end
-- https://pandoc.org/lua-filters.html#type-link
-- function Link(elm) end
-- https://pandoc.org/lua-filters.html#type-math
-- function Math(elm) end
-- https://pandoc.org/lua-filters.html#type-str
-- function Str(elm) end


-- https://pandoc.org/lua-filters.html#type-span
-- Generic inline container
function Span(el)
  -- data-tag is for later on so you can programatically pull the entered text
  -- [Enter your name here]{.cc data-tag="Person Name"}
  -- []{.cc data-tag="Content-Answer"}
	if el.classes:includes('cc') and FORMAT == "docx" then
		return word_contentcontrol(el);
	end
end

-- Filter functions are run in the order: Inlines → Blocks → Meta → Pandoc.

-- Pandoc
-- 	Str
-- 	Para
-- 	Pandoc

-- Pandoc
-- 	blocks
-- 	meta

local function printKV(tbl, indent)
	indent = indent or 0;
	for k,v in pairs(tbl) do
		local pre = "";
		for i = 0, indent, 1 do pre = pre .. "  " end
		if type(v) == "table" then
			print(k);
			printKV(v, indent + 1)
		elseif type(v) == "function" then
			print(pre .. k .. " is a function");
		else
			print(pre .. k .. " " .. v);
		end
	end
end

-- Takes the document's metadata
-- function Meta(m)
-- 	-- print(pandoc.utils.type(m))
-- 	-- If the document's metadata doesn't have a set date
-- 	if m.date == nil then
-- 		-- Use today's date
-- 		m.date = os.date("%B %e, %Y")
-- 		return m -- return to apply
-- 	end
-- end


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
