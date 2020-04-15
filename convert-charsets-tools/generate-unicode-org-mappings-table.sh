#!/usr/bin/env bash

URL_BASE="https://www.unicode.org/Public/MAPPINGS/"
URL_FILE="${1}"	# e.g., "VENDORS/MICSFT/WINDOWS/CP1250.TXT"
NAME_PREFIX="${2}"	# e.g., "MAC_"

[[ -n "${URL_FILE}" ]] && MAPPING=$(wget -O - "${URL_BASE}${URL_FILE}")

if ! echo "${MAPPING}" | grep -q "Table format: \+Format A\| from Mac OS "; then
	echo "Usage:	${0} <path-to-mapping-file> [name-prefix]" >&2
	echo "Generate Lua source of something to Unicode mapping table from the path to a mapping file at ${URL_BASE}" >&2
	exit 1
fi

FILE="${URL_FILE##*/}" BASENAME="${NAME_PREFIX}${FILE%.*}" NAME="${BASENAME//-/_}"

echo "-- adapted from ${URL_BASE}${URL_FILE}"
echo "local mapping_${NAME}_to_UNICODE = {"

echo "${MAPPING}" | while read LINE; do
	[[ "${LINE:0:1}" = "#" ]] && continue
	CHAR_NATIVE=$(echo "${LINE}" | cut -f 1)
	CHAR_UNICODE=$(echo "${LINE}" | cut -f 2)
	CHAR_NAME=$(echo "${LINE}" | cut -d "#" -f 2 | sed 's/^\s\+//g')
	[[ "${CHAR_UNICODE:0:2}" != "0x" || "${CHAR_UNICODE}" == "0x????" ]] && continue
	CHAR_UNICODE=$(echo "${CHAR_UNICODE}" | sed -e 's/^\(.*+.*\)$/{ \1 }/' -e 's/+/, /g')	# expand multi-charsets
	#printf "CHAR_NATIVE=\\x${CHAR_NATIVE:2:2}\n"	# debug
	#printf "CHAR_UNICODE=\\x${CHAR_UNICODE:2:2}\\x${CHAR_UNICODE:4:2}\n"	# debug
	echo "	[${CHAR_NATIVE}] = ${CHAR_UNICODE},	-- ${CHAR_NAME}"
done

echo "}"
echo "return mapping_${NAME}_to_UNICODE"
