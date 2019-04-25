-- some code is adopted from: https://stackoverflow.com/a/41859181 by Egor Skriptunoff

local char, byte, pairs, floor = string.char, string.byte, pairs, math.floor
local table_insert, table_concat = table.insert, table.concat
local unpack = table.unpack or unpack

local function unicode_to_utf8(code)
	-- converts a numeric UTF code (U+code) to the UTF-8 character
	local t, h = {}, 128
	while code >= h do
		t[#t+1] = 128 + code%64
		code = floor(code/64)
		h = h > 32 and 32 or h/2
	end
	t[#t+1] = 256 - 2*h + code
	return char(unpack(t)):reverse()
end

local function utf8_to_unicode(utf8char, pos)
	-- converts an UTF-8 character into the numeric UTF code (U+code) and the number of its bytes
	-- pos = starting byte position inside input string (default 1)
	pos = pos or 1
	local code, size = utf8char:byte(pos), 1
	if code >= 0xC0 and code < 0xFE then
		local mask = 64
		code = code - 128
		repeat
			local next_byte = utf8char:byte(pos + size) or 0
			if next_byte >= 0x80 and next_byte < 0xC0 then
				code, size = (code - mask - 2) * 64 + next_byte, size + 1
			else
				code, size = utf8char:byte(pos), 1
			end
			mask = mask * 32
		until code < mask
	end
	-- returns code, number of bytes in this utf8 char
	return code, size
end

function reverse_table(table)
	-- create a new table with swapped key-value pairs
	local result = {}
	for key, value in pairs(table) do
		result[value] = key
	end
	return result
end

function string.fromutf8(utf8_string, reverse_unicode_mapping_table)
	-- converts a UTF-8 string into the native encoded string by given reverse native-to-unicode mapping table
	local pos, result_1252 = 1, {}
	while pos <= #utf8_string do
		local code, size = utf8_to_unicode(utf8_string, pos)
		pos = pos + size
		code = code < 128 and code or reverse_unicode_mapping_table[code] or ('?'):byte()
		table_insert(result_1252, char(code))
	end
	return table_concat(result_1252)
end

function string.toutf8(native_string, unicode_mapping_table)
	-- converts a native encoded string into the UTF-8 string by given native-to-unicode mapping table
	local result_utf8 = {}
	for pos = 1, #native_string do
		local code = native_string:byte(pos)
		table_insert(result_utf8, unicode_to_utf8(unicode_mapping_table[code] or code))
	end
	return table_concat(result_utf8)
end
