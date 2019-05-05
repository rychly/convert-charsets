-- some code is adopted from: https://stackoverflow.com/a/41859181 by Egor Skriptunoff

-- Imports and dependencies (speed-up the symbols look-up by copying them into a small local namespace that is searched before the huge global namespace)
local char, byte, gmatch, upper = string.char, string.byte, string.gmatch, string.upper
local next, pairs, type, assert = next, pairs, type, assert
local floor = math.floor
local stdin, stdout, stderr, open, close, read, write = io.stdin, io.stdout, io.stderr, io.open, io.close, io.read, io.write
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
	if ((reverse_unicode_mapping_table == nil) or (next(reverse_unicode_mapping_table) == nil)) then
		return utf8_string
	else
		local pos, result_native = 1, {}
		while pos <= #utf8_string do
			local code, size = convert_charsets.utf8_to_unicode(utf8_string, pos)
			pos = pos + size
			code = code < 128 and code or reverse_unicode_mapping_table[code] or ('?'):byte()
			table_insert(result_native, type(code) == "number" and char(code) or code)
		end
		return table_concat(result_native)
	end
end

-- converts a native encoded string into the UTF-8 string by given native-to-unicode mapping table
function convert_charsets.to_utf8(native_string, unicode_mapping_table)
	if ((unicode_mapping_table == nil) or (next(unicode_mapping_table) == nil)) then
		return native_string
	else
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
end

-- get a mapping table going from utf-8 to a given charset
function convert_charsets.get_mapping_table_from_utf8(to_charset)
	if (to_charset == "UTF_8") then
		return {}
	elseif (to_charset == "ASCII") then
		return require("convert_charsets.UNICODE_to_" .. to_charset)
	else
		return convert_charsets.reverse_mapping_table(require("convert_charsets." .. to_charset .. "_to_UNICODE"))
	end
end

-- get a mapping table going from a given charset to utf-8
function convert_charsets.get_mapping_table_to_utf8(from_charset)
	if (from_charset == "UTF_8") then
		return {}
	else
		return require("convert_charsets." .. from_charset .. "_to_UNICODE")
	end
end

-- convert string between charsets
function convert_charsets.convert_charsets(input_string, from_charset, to_charset)
	local to_utf8_mapping_table = (type(from_charset) == "table") and from_charset or convert_charsets.get_mapping_table_to_utf8(from_charset)
	local from_utf8_mapping_table = (type(to_charset) == "table") and to_charset or convert_charsets.get_mapping_table_from_utf8(to_charset)
	local input_string_in_utf8 = convert_charsets.to_utf8(input_string, to_utf8_mapping_table)
	return convert_charsets.from_utf8(input_string_in_utf8, from_utf8_mapping_table)
end

-- main method for CLI
function convert_charsets.main(arg)
	if (#arg == 0 or arg[#arg] == "--help") then
		stderr:write("Usage: " .. arg[0] .. " <from_charset>-<to_charset> [input_file] [output_file]\n")
		stderr:write("Converts a given input file (or the standard input stream) to a given output file (or the standard output stream) from the first given charset to the second given charset.\n")
		return 1
	end
	local filter_parsed = arg[1]:upper():gmatch("[^-]+")
	local filter_from, filter_to = convert_charsets.get_mapping_table_to_utf8(filter_parsed()), convert_charsets.get_mapping_table_from_utf8(filter_parsed())
	local file_in = (#arg >= 2 and arg[2] ~= "-") and assert(open(arg[2], "r")) or stdin
	local file_out = (#arg >= 3 and arg[3] ~= "-") and assert(open(arg[3], "w")) or stdout
	while true do
		local line = file_in:read("*l")
		if (line == nil) then
			break
		else
			file_out:write(convert_charsets.convert_charsets(line, filter_from, filter_to) .. "\n")
		end
	end
	file_out:close()
	file_in:close()
	return 0
end

string.from_utf8 = convert_charsets.from_utf8
string.to_utf8 = convert_charsets.to_utf8
table.swap_keys_and_vals = convert_charsets.reverse_mapping_table

return convert_charsets
