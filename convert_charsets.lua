-- some code is adopted from: https://stackoverflow.com/a/41859181 by Egor Skriptunoff

-- Imports and dependencies (speed-up the symbols look-up by copying them into a small local namespace that is searched before the huge global namespace)
local char, byte, gmatch, sub, upper = string.char, string.byte, string.gmatch, string.sub, string.upper
local next, pairs, ipairs, type, assert = next, pairs, ipairs, type, assert
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
			-- two-bytes character first
			local unicode = code2 and unicode_mapping_table[code1*256 + code2]
			if (unicode) then
				pos = pos + 1
			else
				-- one-byte character next
				unicode = unicode_mapping_table[code1]
				if (not unicode) then
					-- fallback to the original character
					unicode = code1
				end
			end
			-- unicode can be a single number, an array of numbers, or single/array of chars
			for _, unicode_char in ipairs(type(unicode) == "table" and unicode or { unicode }) do
				table_insert(result_utf8, type(unicode_char) == "number" and convert_charsets.unicode_to_utf8(unicode_char) or unicode_char)
			end
		end
		return table_concat(result_utf8)
	end
end

-- get a mapping table going from utf-8 to a given charset
function convert_charsets.get_mapping_table_from_utf8(to_charset)
	if (to_charset == "UTF_8") then
		return {}
	elseif ((to_charset == "ASCII") or (to_charset == "SGML")) then
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

-- normalize charset names
function convert_charsets.normalize_charset_name(charset)
	local charset_names = {
		-- cstools:cstocs
		["UTF8"] = "UTF_8",
		["IL1"] = "8859_1",
		["IL2"] = "8859_2",
		["PC1"] = "CP850",
		["PC2"] = "CP852",
		["1250"] = "CP1250",
		["1252"] = "CP1252",
		["MACCE"] = "MAC_CENTEURO",
		-- konwert
		["ISO1"] = "8859_1",
		["ISO2"] = "8859_2",
		["ISO3"] = "8859_3",
		["ISO4"] = "8859_4",
		["ISO5"] = "8859_5",
		["ISO6"] = "8859_6",
		["ISO7"] = "8859_7",
		["ISO8"] = "8859_8",
		["ISO9"] = "8859_9",
		["ISO10"] = "8859_10",
		["ISO11"] = "8859_11",
		["ISO12"] = "8859_12",
		["ISO13"] = "8859_13",
		["ISO14"] = "8859_14",
		["ISO15"] = "8859_15",
		["ISO16"] = "8859_16",
		["ISOLATIN1"] = "8859_1",
		["ISOLATIN2"] = "8859_2",
		["ISOLATIN3"] = "8859_3",
		["ISOLATIN4"] = "8859_4",
		["ISOLATIN5"] = "8859_5",
		["ISOLATIN6"] = "8859_6",
		["ISOLATIN7"] = "8859_7",
		["ISOLATIN8"] = "8859_8",
		["ISOLATIN9"] = "8859_9",
		["DOSGREEK"] = "CP737",
		["DOSBALTIC"] = "CP775",
		["DOSLATIN1"] = "CP850",
		["DOSLATIN2"] = "CP852",
		["DOSCYR"] = "CP855",
		["DOSTUR"] = "CP857",
		["DOSICELAND"] = "CP861",
		["DOSHEBREW"] = "CP862",
		["DOSCANADAFR"] = "CP863",
		["DOSARABIC"] = "CP864",
		["DOSNORDIC"] = "CP865",
		["DOSRUSSIAN"] = "CP866",
		["DOSGREEK2"] = "CP869",
		["DOSTHAI"] = "CP874",
		["WINLATIN2"] = "CP1250",
		["WINLATIN1"] = "CP1252",
		["WINCYR"] = "CP1251",
		["WINGREEK"] = "CP1253",
		["WINTUR"] = "CP1254",
		["WINHEBREW"] = "CP1255",
		["WINARABIC"] = "CP1256",
		["WINBALTIC"] = "CP1257",
		["WINVIET"] = "CP1258",
		["KOI8R"] = "KOI8_R",
		["KOI8U"] = "KOI8_U",
		["HTMLENT"] = "SGML",
		-- iconv
		["437"] = "CP427",
		["850"] = "CP850",
		["852"] = "CP852",
		["855"] = "CP855",
		["857"] = "CP857",
		["860"] = "CP860",
		["861"] = "CP861",
		["862"] = "CP862",
		["863"] = "CP863",
		["864"] = "CP864",
		["865"] = "CP865",
		["866"] = "CP866",
		["869"] = "CP869",
		["874"] = "CP874",
		["ISO8859_1"] = "8859_1",
		["ISO8859_2"] = "8859_2",
		["ISO8859_3"] = "8859_3",
		["ISO8859_4"] = "8859_4",
		["ISO8859_5"] = "8859_5",
		["ISO8859_6"] = "8859_6",
		["ISO8859_7"] = "8859_7",
		["ISO8859_8"] = "8859_8",
		["ISO8859_9"] = "8859_9",
		["ISO8859_10"] = "8859_10",
		["ISO8859_11"] = "8859_11",
		["ISO8859_12"] = "8859_12",
		["ISO8859_13"] = "8859_13",
		["ISO8859_14"] = "8859_14",
		["ISO8859_15"] = "8859_15",
		["ISO8859_16"] = "8859_16",
		["ISO_8859_1"] = "8859_1",
		["ISO_8859_2"] = "8859_2",
		["ISO_8859_3"] = "8859_3",
		["ISO_8859_4"] = "8859_4",
		["ISO_8859_5"] = "8859_5",
		["ISO_8859_6"] = "8859_6",
		["ISO_8859_7"] = "8859_7",
		["ISO_8859_8"] = "8859_8",
		["ISO_8859_9"] = "8859_9",
		["ISO_8859_10"] = "8859_10",
		["ISO_8859_11"] = "8859_11",
		["ISO_8859_12"] = "8859_12",
		["ISO_8859_13"] = "8859_13",
		["ISO_8859_14"] = "8859_14",
		["ISO_8859_15"] = "8859_15",
		["ISO_8859_16"] = "8859_16",
		["LATIN1"] = "8859_1",
		["LATIN2"] = "8859_2",
		["LATIN3"] = "8859_3",
		["LATIN4"] = "8859_4",
		["LATIN5"] = "8859_5",
		["LATIN6"] = "8859_6",
		["LATIN7"] = "8859_7",
		["LATIN8"] = "8859_8",
		["LATIN9"] = "8859_9",
		["LATIN10"] = "8859_10",
		["L1"] = "8859_1",
		["L2"] = "8859_2",
		["L3"] = "8859_3",
		["L4"] = "8859_4",
		["L5"] = "8859_5",
		["L6"] = "8859_6",
		["L7"] = "8859_7",
		["L8"] = "8859_8",
		["L9"] = "8859_9",
		["L10"] = "8859_10",
		["WINDOWS_874"] = "CP874",
		["WINDOWS_1250"] = "CP1250",
		["WINDOWS_1251"] = "CP1251",
		["WINDOWS_1252"] = "CP1252",
		["WINDOWS_1253"] = "CP1253",
		["WINDOWS_1254"] = "CP1254",
		["WINDOWS_1255"] = "CP1255",
		["WINDOWS_1256"] = "CP1256",
		["WINDOWS_1257"] = "CP1257",
		["WINDOWS_1258"] = "CP1258",
	}
	return charset_names[charset] or charset
end

-- convert string between charsets
function convert_charsets.convert_charsets(input_string, from_charset, to_charset)
	local to_utf8_mapping_table = (type(from_charset) == "table") and from_charset or convert_charsets.get_mapping_table_to_utf8(convert_charsets.normalize_charset_name(from_charset))
	local from_utf8_mapping_table = (type(to_charset) == "table") and to_charset or convert_charsets.get_mapping_table_from_utf8(convert_charsets.normalize_charset_name(to_charset))
	local input_string_in_utf8 = convert_charsets.to_utf8(input_string, to_utf8_mapping_table)
	return convert_charsets.from_utf8(input_string_in_utf8, from_utf8_mapping_table)
end

-- main method for CLI
function convert_charsets.main(arg)
	if (#arg == 0 or arg[#arg] == "--help") then
		stderr:write("Usage: " .. arg[0] .. " <from_charset>-<to_charset> [input_file...] [-o <output_file>]\n")
		stderr:write("Usage: " .. arg[0] .. " -f <from_charset> -t <to_charset> [input_file...] [-o <output_file>]\n")
		stderr:write("Usage: " .. arg[0] .. " --from-code=<from_charset> --to-code=<to_charset> [input_file...] [--output=<output_file>]\n")
		stderr:write("Converts given input file(s) (or the standard input stream) to a given output file (or the standard output stream) from the first given charset to the second given charset encodings.\n")
		return 1
	end
	-- parse optargs
	local opt_from_code, opt_to_code
	local opt_input, opt_output = {}, "-"
	local i = 1
	while i <= #arg do
		if (arg[i] == "-f") then
			opt_from_code = arg[i + 1]
			i = i + 1
		elseif (arg[i] == "-t") then
			opt_to_code = arg[i + 1]
			i = i + 1
		elseif (arg[i] == "-o") then
			opt_output = arg[i + 1]
			i = i + 1
		elseif (arg[i]:sub(1,12) == "--from-code=") then
			opt_from_code = arg[i]:sub(13)
		elseif (arg[i]:sub(1,10) == "--to-code=") then
			opt_to_code = arg[i]:sub(11)
		elseif (arg[i]:sub(1,9) == "--output=") then
			opt_output = arg[i]:sub(10)
		elseif (arg[i] ~= "-" and arg[i]:sub(1,1) == "-") then
			stderr:write("Unsupported option '", arg[i], "'.\n")
			return 2
		elseif (i == 1) then
			local filter_parsed = arg[i]:gmatch("[^-]+")
			opt_from_code = filter_parsed()
			opt_to_code = filter_parsed()
		else
			table_insert(opt_input, arg[i])
		end
		i = i + 1
	end
	if (opt_from_code == nil or opt_to_code == nil) then
		stderr:write("Missing options for the source and target charsets/encodings.\n")
		return 2
	end
	-- prepare charsets
	opt_from_code = opt_from_code:upper():gsub("-", "_")
	opt_to_code = opt_to_code:upper():gsub("-", "_")
	local filter_from = convert_charsets.get_mapping_table_to_utf8(convert_charsets.normalize_charset_name(opt_from_code))
	local filter_to = convert_charsets.get_mapping_table_from_utf8(convert_charsets.normalize_charset_name(opt_to_code))
	-- process files
	local file_out = (opt_output == "-") and stdout or assert(open(opt_output, "w"))
	for _, opt_input_single in ipairs((#opt_input > 0) and opt_input or {"-"}) do
		local file_in = (opt_input_single == "-") and stdin or assert(open(opt_input_single, "r"))
		while true do
			local line = file_in:read("*l")
			if (line == nil) then
				break
			else
				file_out:write(convert_charsets.convert_charsets(line, filter_from, filter_to) .. "\n")
			end
		end
		file_in:close()
	end
	file_out:close()
	return 0
end

string.from_utf8 = convert_charsets.from_utf8
string.to_utf8 = convert_charsets.to_utf8
table.swap_keys_and_vals = convert_charsets.reverse_mapping_table

return convert_charsets
