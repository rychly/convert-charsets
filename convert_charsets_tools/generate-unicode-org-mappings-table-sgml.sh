#!/usr/bin/env bash

URL="https://www.unicode.org/Public/MAPPINGS/VENDORS/MISC/SGML.TXT"

if [[ "${1}" = "--help" ]]; then
	echo "Usage:	${0}" >&2
	echo "Generate Lua source of Unicode to SGML mapping table from the mapping file at ${URL}" >&2
	exit 1
fi

MAPPING=$(wget -O - "${URL}")

FILE=${URL##*/} BASENAME=${FILE%.*} NAME=${BASENAME//-/_}

echo "-- adapted from ${URL}"
echo "local mapping_UNICODE_to_${NAME} = {"

echo "${MAPPING}" | while read LINE; do
	[[ "${LINE:0:1}" = "#" ]] && continue
	CHAR_NATIVE=$(echo "${LINE}" | cut -f 1)
	CHAR_UNICODE=$(echo "${LINE}" | cut -f 3)
	CHAR_NAME=$(echo "${LINE}" | cut -d "#" -f 2 | sed 's/^\s\+//g')
	[[ "${CHAR_UNICODE:0:2}" != "0x" || "${CHAR_UNICODE}" == "0x????" ]] && continue
	#printf "CHAR_NATIVE=${CHAR_NATIVE}\n"	# debug
	#printf "CHAR_UNICODE=\\x${CHAR_UNICODE:2:2}\\x${CHAR_UNICODE:4:2}\n"	# debug
	echo "	[${CHAR_UNICODE}] = \"&${CHAR_NATIVE};\",	-- ${CHAR_NAME}"
done

echo "}"
echo "return mapping_UNICODE_to_${NAME}"
