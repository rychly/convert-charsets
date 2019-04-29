-- some code is adopted from: https://stackoverflow.com/a/41859181 by Egor Skriptunoff

-- Imports and dependencies
local char, byte, pairs, floor = string.char, string.byte, pairs, math.floor
local table_insert, table_concat = table.insert, table.concat
local unpack = table.unpack or unpack

-- Module declaration
local convert_charsets = {} -- Public namespace
local convert_charsets_private = {} -- Private namespace

-- PUBLIC FUNCTIONS

-- converts a numeric UTF code (U+code) to the UTF-8 character
function convert_charsets.unicode_to_utf8(code)
	local t, h = {}, 128
	while code >= h do
		t[#t+1] = 128 + code%64
		code = floor(code/64)
		h = h > 32 and 32 or h/2
	end
	t[#t+1] = 256 - 2*h + code
	return char(unpack(t)):reverse()
end

-- converts an UTF-8 character into the numeric UTF code (U+code) and the number of its bytes
function convert_charsets.utf8_to_unicode(utf8char, pos)
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

-- create a new table with swapped key-value pairs
function convert_charsets.reverse_mapping_table(table)
	local result = {}
	for key, value in pairs(table) do
		result[value] = key
	end
	return result
end

-- converts a UTF-8 string into the native encoded string by given reverse native-to-unicode mapping table (of items "[codepoint] = code" or "[codepoint] = 'string'")
function convert_charsets.from_utf8(utf8_string, reverse_unicode_mapping_table)
	local pos, result_native = 1, {}
	while pos <= #utf8_string do
		local code, size = convert_charsets.utf8_to_unicode(utf8_string, pos)
		pos = pos + size
		code = code < 128 and code or reverse_unicode_mapping_table[code] or ('?'):byte()
		table_insert(result_native, type(code) == "number" and char(code) or code)
	end
	return table_concat(result_native)
end

-- converts a native encoded string into the UTF-8 string by given native-to-unicode mapping table
function convert_charsets.to_utf8(native_string, unicode_mapping_table)
	local result_utf8 = {}
	for pos = 1, #native_string do
		local code1, code2 = native_string:byte(pos, pos+1)
		-- one-byte character
		local unicode = unicode_mapping_table[code1]
		-- two-bytes character
		if (not unicode and code2) then
			unicode = unicode_mapping_table[code1*256 + code2]
			pos = pos + 1
		end
		-- fallback to the original character
		if (not unicode) then
			unicode = code1
		end
		table_insert(result_utf8, convert_charsets.unicode_to_utf8(unicode))
	end
	return table_concat(result_utf8)
end

-- convert string between charsets
function convert_charsets.convert_charsets(input_string, from_charset, to_charset)
	if (from_charset == "UTF_8" and to_charset ~= "ASCII") then
		local reverse_unicode_mapping_table = convert_charsets.reverse_mapping_table(require("convert_charsets." .. to_charset .. "_to_UNICODE"))
		return convert_charsets.from_utf8(input_string, reverse_unicode_mapping_table)
	elseif (from_charset == "UTF_8" and to_charset == "ASCII") then
		local reverse_unicode_mapping_table = require("convert_charsets.UNICODE_to_" .. to_charset)
		return convert_charsets.from_utf8(input_string, reverse_unicode_mapping_table)
	elseif (to_charset == "UTF_8") then
		local unicode_mapping_table = require("convert_charsets." .. from_charset .. "_to_UNICODE")
		return convert_charsets.to_utf8(input_string, unicode_mapping_table)
	else
		local to_utf8 = convert_charsets.convert_charsets(input_string, from_charset, "UTF_8")
		local from_utf8 = convert_charsets.convert_charsets(to_utf8, "UTF_8", to_charset)
		return from_utf8
	end
end

-- main method for CLI
function convert_charsets.main(arg)
	if (#arg == 0 or arg[#arg] == "--help") then
		io.stderr:write("Usage: " .. arg[0] .. " <from_charset>-<to_charset> [input_file]\n")
		io.stderr:write("Converts a given file or the standard input stream from the first given charset to the second given charset.\n")
		return 1
	end
	local filter_parsed = arg[1]:upper():gmatch("[^-]+")
	local filter_from, filter_to = filter_parsed(), filter_parsed()
	local file = #arg > 1 and assert(io.open(arg[2], "r")) or io.stdin
	while true do
		local line = file:read("*l")
		if (line == nil) then
			break
		else
			print (convert_charsets.convert_charsets(line, filter_from, filter_to))
		end
	end
	file:close()
	return 0
end

string.from_utf8 = convert_charsets.from_utf8
string.to_utf8 = convert_charsets.to_utf8
table.swap_keys_and_vals = convert_charsets.reverse_mapping_table

return convert_charsets
