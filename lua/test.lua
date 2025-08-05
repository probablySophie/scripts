
local current_file = debug.getinfo(1, "S").short_src;
local path = string.match(current_file, ".*/") or "";

require (path.."test2");

print("Current File: " .. current_file);
print("Path: " .. path);

local a = {
	{ name = "Hi" }
};

for i,v in pairs(a) do
	if type(v) == "table" then
		for i2,v2 in pairs(v) do
			print (i .. " > " .. i2 .. " - " .. v2);
		end
	else
		print(i .. " - " .. v);
	end
end


-- print(debug.getinfo(2, ""));
-- str = debug.getinfo(2, "").source:sub(2);
