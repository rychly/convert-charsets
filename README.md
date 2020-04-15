# Convert Strings between Charsets in Lua

Lua scripts to convert strings between UTF-8 and other charsets and from UTF-8 to ASCII and SGML.

## Shell Script `convert-charsets.sh`

### Usage

*	`./convert-charsets.sh <from_charset>-<to_charset> [input_file...] [-o <output_file>]`
*	`./convert-charsets.sh -f <from_charset> -t <to_charset> [input_file...] [-o <output_file>]`
*	`./convert-charsets.sh --from-code=<from_charset> --to-code=<to_charset> [input_file...] [--output=<output_file>]`

Converts given input file(s) (or the standard input stream) to a given output file (or the standard output stream) from the first given charset to the second given charset encodings.
The charset encodings can be combined by '+' operator, e.g., 'utf8-gsm+ascii' will convert from UTF-8 to GSM with fallback to UTF-8 to ASCII form chars not in GSM.

### Example

~~~
echo "příliš žluťoučký kůň" $'\n' "pěl ďábelské ódy" | ./convert-charsets.sh utf_8-8859_2 | ./convert-charsets.sh 8859_2-cp1250 | ./convert-charsets.sh cp1250-ascii
~~~

## License

Files `convert-charsets/*_to_UNICODE.lua` are subjects of licensing according to the [Unicode Data Files and Software License](https://www.unicode.org/license.html)
as they are derived/adapted from [Unicode DATA FILES](https://www.unicode.org/Public/MAPPINGS/).

File `convert-charsets/UNICODE_to_ASCII.lua` is the subject of licensing according to the [GNU General Public License version 2.0 (GPLv2)](https://www.gnu.org/licenses/old-licenses/gpl-2.0.html)
as it is derived/adapted from [Konwert](https://sourceforge.net/projects/konwert/).

The rest of files are subjects of licensing according to the [GNU General Public License version 2.0 (GPLv2)](https://www.gnu.org/licenses/old-licenses/gpl-2.0.html).
