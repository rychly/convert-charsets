# Convert Strings between Charsets in Lua

Lua scripts to convert strings between UTF-8 and other charsets and from UTF-8 to ASCII.

## Shell Script `convert_charsets*.sh`

Usage `./convert_charsets-nix.sh <from_charset>-<to_charset> [input_file] [output_file]`

Converts a given input file (or the standard input stream) to a given output file (or the standard output stream) from the first given charset to the second given charset.

Example:

~~~
echo "příliš žluťoučký kůň" $'\n' "pěl ďábelské ódy" | ./convert_charsets-nix.sh utf_8-8859_2 | ./convert_charsets-nix.sh 8859_2-cp1250 | ./convert_charsets-nix.sh cp1250-ascii
~~~

## License

Files `convert_charsets/*_to_UNICODE.lua` are subjects of licensing according to the [Unicode Data Files and Software License](https://www.unicode.org/license.html)
as they are derived/adapted from [Unicode DATA FILES](https://www.unicode.org/Public/MAPPINGS/).

File `convert_charsets/UNICODE_to_ASCII.lua` is the subject of licensing according to the [GNU General Public License version 2.0 (GPLv2)](https://www.gnu.org/licenses/old-licenses/gpl-2.0.html)
as it is derived/adapted from [Konwert](https://sourceforge.net/projects/konwert/).

The rest of files are subjects of licensing according to the [GNU General Public License version 2.0 (GPLv2)](https://www.gnu.org/licenses/old-licenses/gpl-2.0.html).
