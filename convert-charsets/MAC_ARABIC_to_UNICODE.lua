-- adapted from https://www.unicode.org/Public/MAPPINGS/VENDORS/APPLE/ARABIC.TXT
local mapping_MAC_ARABIC_to_UNICODE = {
	[0x30] = 0x0030,	-- DIGIT ZERO;  in Arabic-script context, displayed as 0x0660 ARABIC-INDIC DIGIT ZERO
	[0x31] = 0x0031,	-- DIGIT ONE;   in Arabic-script context, displayed as 0x0661 ARABIC-INDIC DIGIT ONE
	[0x32] = 0x0032,	-- DIGIT TWO;   in Arabic-script context, displayed as 0x0662 ARABIC-INDIC DIGIT TWO
	[0x33] = 0x0033,	-- DIGIT THREE; in Arabic-script context, displayed as 0x0663 ARABIC-INDIC DIGIT THREE
	[0x34] = 0x0034,	-- DIGIT FOUR;  in Arabic-script context, displayed as 0x0664 ARABIC-INDIC DIGIT FOUR
	[0x35] = 0x0035,	-- DIGIT FIVE;  in Arabic-script context, displayed as 0x0665 ARABIC-INDIC DIGIT FIVE
	[0x36] = 0x0036,	-- DIGIT SIX;   in Arabic-script context, displayed as 0x0666 ARABIC-INDIC DIGIT SIX
	[0x37] = 0x0037,	-- DIGIT SEVEN; in Arabic-script context, displayed as 0x0667 ARABIC-INDIC DIGIT SEVEN
	[0x38] = 0x0038,	-- DIGIT EIGHT; in Arabic-script context, displayed as 0x0668 ARABIC-INDIC DIGIT EIGHT
	[0x39] = 0x0039,	-- DIGIT NINE;  in Arabic-script context, displayed as 0x0669 ARABIC-INDIC DIGIT NINE
	[0x40] = 0x0040,	-- COMMERCIAL AT
	[0x41] = 0x0041,	-- LATIN CAPITAL LETTER A
	[0x42] = 0x0042,	-- LATIN CAPITAL LETTER B
	[0x43] = 0x0043,	-- LATIN CAPITAL LETTER C
	[0x44] = 0x0044,	-- LATIN CAPITAL LETTER D
	[0x45] = 0x0045,	-- LATIN CAPITAL LETTER E
	[0x46] = 0x0046,	-- LATIN CAPITAL LETTER F
	[0x47] = 0x0047,	-- LATIN CAPITAL LETTER G
	[0x48] = 0x0048,	-- LATIN CAPITAL LETTER H
	[0x49] = 0x0049,	-- LATIN CAPITAL LETTER I
	[0x4A] = 0x004A,	-- LATIN CAPITAL LETTER J
	[0x4B] = 0x004B,	-- LATIN CAPITAL LETTER K
	[0x4C] = 0x004C,	-- LATIN CAPITAL LETTER L
	[0x4D] = 0x004D,	-- LATIN CAPITAL LETTER M
	[0x4E] = 0x004E,	-- LATIN CAPITAL LETTER N
	[0x4F] = 0x004F,	-- LATIN CAPITAL LETTER O
	[0x50] = 0x0050,	-- LATIN CAPITAL LETTER P
	[0x51] = 0x0051,	-- LATIN CAPITAL LETTER Q
	[0x52] = 0x0052,	-- LATIN CAPITAL LETTER R
	[0x53] = 0x0053,	-- LATIN CAPITAL LETTER S
	[0x54] = 0x0054,	-- LATIN CAPITAL LETTER T
	[0x55] = 0x0055,	-- LATIN CAPITAL LETTER U
	[0x56] = 0x0056,	-- LATIN CAPITAL LETTER V
	[0x57] = 0x0057,	-- LATIN CAPITAL LETTER W
	[0x58] = 0x0058,	-- LATIN CAPITAL LETTER X
	[0x59] = 0x0059,	-- LATIN CAPITAL LETTER Y
	[0x5A] = 0x005A,	-- LATIN CAPITAL LETTER Z
	[0x60] = 0x0060,	-- GRAVE ACCENT
	[0x61] = 0x0061,	-- LATIN SMALL LETTER A
	[0x62] = 0x0062,	-- LATIN SMALL LETTER B
	[0x63] = 0x0063,	-- LATIN SMALL LETTER C
	[0x64] = 0x0064,	-- LATIN SMALL LETTER D
	[0x65] = 0x0065,	-- LATIN SMALL LETTER E
	[0x66] = 0x0066,	-- LATIN SMALL LETTER F
	[0x67] = 0x0067,	-- LATIN SMALL LETTER G
	[0x68] = 0x0068,	-- LATIN SMALL LETTER H
	[0x69] = 0x0069,	-- LATIN SMALL LETTER I
	[0x6A] = 0x006A,	-- LATIN SMALL LETTER J
	[0x6B] = 0x006B,	-- LATIN SMALL LETTER K
	[0x6C] = 0x006C,	-- LATIN SMALL LETTER L
	[0x6D] = 0x006D,	-- LATIN SMALL LETTER M
	[0x6E] = 0x006E,	-- LATIN SMALL LETTER N
	[0x6F] = 0x006F,	-- LATIN SMALL LETTER O
	[0x70] = 0x0070,	-- LATIN SMALL LETTER P
	[0x71] = 0x0071,	-- LATIN SMALL LETTER Q
	[0x72] = 0x0072,	-- LATIN SMALL LETTER R
	[0x73] = 0x0073,	-- LATIN SMALL LETTER S
	[0x74] = 0x0074,	-- LATIN SMALL LETTER T
	[0x75] = 0x0075,	-- LATIN SMALL LETTER U
	[0x76] = 0x0076,	-- LATIN SMALL LETTER V
	[0x77] = 0x0077,	-- LATIN SMALL LETTER W
	[0x78] = 0x0078,	-- LATIN SMALL LETTER X
	[0x79] = 0x0079,	-- LATIN SMALL LETTER Y
	[0x7A] = 0x007A,	-- LATIN SMALL LETTER Z
	[0x7E] = 0x007E,	-- TILDE
	[0x80] = 0x00C4,	-- LATIN CAPITAL LETTER A WITH DIAERESIS
	[0x82] = 0x00C7,	-- LATIN CAPITAL LETTER C WITH CEDILLA
	[0x83] = 0x00C9,	-- LATIN CAPITAL LETTER E WITH ACUTE
	[0x84] = 0x00D1,	-- LATIN CAPITAL LETTER N WITH TILDE
	[0x85] = 0x00D6,	-- LATIN CAPITAL LETTER O WITH DIAERESIS
	[0x86] = 0x00DC,	-- LATIN CAPITAL LETTER U WITH DIAERESIS
	[0x87] = 0x00E1,	-- LATIN SMALL LETTER A WITH ACUTE
	[0x88] = 0x00E0,	-- LATIN SMALL LETTER A WITH GRAVE
	[0x89] = 0x00E2,	-- LATIN SMALL LETTER A WITH CIRCUMFLEX
	[0x8A] = 0x00E4,	-- LATIN SMALL LETTER A WITH DIAERESIS
	[0x8B] = 0x06BA,	-- ARABIC LETTER NOON GHUNNA
	[0x8D] = 0x00E7,	-- LATIN SMALL LETTER C WITH CEDILLA
	[0x8E] = 0x00E9,	-- LATIN SMALL LETTER E WITH ACUTE
	[0x8F] = 0x00E8,	-- LATIN SMALL LETTER E WITH GRAVE
	[0x90] = 0x00EA,	-- LATIN SMALL LETTER E WITH CIRCUMFLEX
	[0x91] = 0x00EB,	-- LATIN SMALL LETTER E WITH DIAERESIS
	[0x92] = 0x00ED,	-- LATIN SMALL LETTER I WITH ACUTE
	[0x94] = 0x00EE,	-- LATIN SMALL LETTER I WITH CIRCUMFLEX
	[0x95] = 0x00EF,	-- LATIN SMALL LETTER I WITH DIAERESIS
	[0x96] = 0x00F1,	-- LATIN SMALL LETTER N WITH TILDE
	[0x97] = 0x00F3,	-- LATIN SMALL LETTER O WITH ACUTE
	[0x99] = 0x00F4,	-- LATIN SMALL LETTER O WITH CIRCUMFLEX
	[0x9A] = 0x00F6,	-- LATIN SMALL LETTER O WITH DIAERESIS
	[0x9C] = 0x00FA,	-- LATIN SMALL LETTER U WITH ACUTE
	[0x9D] = 0x00F9,	-- LATIN SMALL LETTER U WITH GRAVE
	[0x9E] = 0x00FB,	-- LATIN SMALL LETTER U WITH CIRCUMFLEX
	[0x9F] = 0x00FC,	-- LATIN SMALL LETTER U WITH DIAERESIS
	[0xA5] = 0x066A,	-- ARABIC PERCENT SIGN
	[0xAC] = 0x060C,	-- ARABIC COMMA
	[0xBB] = 0x061B,	-- ARABIC SEMICOLON
	[0xBF] = 0x061F,	-- ARABIC QUESTION MARK
	[0xC1] = 0x0621,	-- ARABIC LETTER HAMZA
	[0xC2] = 0x0622,	-- ARABIC LETTER ALEF WITH MADDA ABOVE
	[0xC3] = 0x0623,	-- ARABIC LETTER ALEF WITH HAMZA ABOVE
	[0xC4] = 0x0624,	-- ARABIC LETTER WAW WITH HAMZA ABOVE
	[0xC5] = 0x0625,	-- ARABIC LETTER ALEF WITH HAMZA BELOW
	[0xC6] = 0x0626,	-- ARABIC LETTER YEH WITH HAMZA ABOVE
	[0xC7] = 0x0627,	-- ARABIC LETTER ALEF
	[0xC8] = 0x0628,	-- ARABIC LETTER BEH
	[0xC9] = 0x0629,	-- ARABIC LETTER TEH MARBUTA
	[0xCA] = 0x062A,	-- ARABIC LETTER TEH
	[0xCB] = 0x062B,	-- ARABIC LETTER THEH
	[0xCC] = 0x062C,	-- ARABIC LETTER JEEM
	[0xCD] = 0x062D,	-- ARABIC LETTER HAH
	[0xCE] = 0x062E,	-- ARABIC LETTER KHAH
	[0xCF] = 0x062F,	-- ARABIC LETTER DAL
	[0xD0] = 0x0630,	-- ARABIC LETTER THAL
	[0xD1] = 0x0631,	-- ARABIC LETTER REH
	[0xD2] = 0x0632,	-- ARABIC LETTER ZAIN
	[0xD3] = 0x0633,	-- ARABIC LETTER SEEN
	[0xD4] = 0x0634,	-- ARABIC LETTER SHEEN
	[0xD5] = 0x0635,	-- ARABIC LETTER SAD
	[0xD6] = 0x0636,	-- ARABIC LETTER DAD
	[0xD7] = 0x0637,	-- ARABIC LETTER TAH
	[0xD8] = 0x0638,	-- ARABIC LETTER ZAH
	[0xD9] = 0x0639,	-- ARABIC LETTER AIN
	[0xDA] = 0x063A,	-- ARABIC LETTER GHAIN
	[0xE0] = 0x0640,	-- ARABIC TATWEEL
	[0xE1] = 0x0641,	-- ARABIC LETTER FEH
	[0xE2] = 0x0642,	-- ARABIC LETTER QAF
	[0xE3] = 0x0643,	-- ARABIC LETTER KAF
	[0xE4] = 0x0644,	-- ARABIC LETTER LAM
	[0xE5] = 0x0645,	-- ARABIC LETTER MEEM
	[0xE6] = 0x0646,	-- ARABIC LETTER NOON
	[0xE7] = 0x0647,	-- ARABIC LETTER HEH
	[0xE8] = 0x0648,	-- ARABIC LETTER WAW
	[0xE9] = 0x0649,	-- ARABIC LETTER ALEF MAKSURA
	[0xEA] = 0x064A,	-- ARABIC LETTER YEH
	[0xEB] = 0x064B,	-- ARABIC FATHATAN
	[0xEC] = 0x064C,	-- ARABIC DAMMATAN
	[0xED] = 0x064D,	-- ARABIC KASRATAN
	[0xEE] = 0x064E,	-- ARABIC FATHA
	[0xEF] = 0x064F,	-- ARABIC DAMMA
	[0xF0] = 0x0650,	-- ARABIC KASRA
	[0xF1] = 0x0651,	-- ARABIC SHADDA
	[0xF2] = 0x0652,	-- ARABIC SUKUN
	[0xF3] = 0x067E,	-- ARABIC LETTER PEH
	[0xF4] = 0x0679,	-- ARABIC LETTER TTEH
	[0xF5] = 0x0686,	-- ARABIC LETTER TCHEH
	[0xF6] = 0x06D5,	-- ARABIC LETTER AE
	[0xF7] = 0x06A4,	-- ARABIC LETTER VEH
	[0xF8] = 0x06AF,	-- ARABIC LETTER GAF
	[0xF9] = 0x0688,	-- ARABIC LETTER DDAL
	[0xFA] = 0x0691,	-- ARABIC LETTER RREH
	[0xFE] = 0x0698,	-- ARABIC LETTER JEH
	[0xFF] = 0x06D2,	-- ARABIC LETTER YEH BARREE
}
return mapping_MAC_ARABIC_to_UNICODE
