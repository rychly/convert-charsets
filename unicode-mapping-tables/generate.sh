#!/usr/bin/env bash

TABLES="
VENDORS/MICSFT/WINDOWS/CP1250.TXT
ISO8859/8859-2.TXT
"

for I in ${TABLES}; do
	FILE=${I##*/} BASENAME=${FILE%.*} NAME=${BASENAME//-/_}
	echo "Generating table for ${NAME} ..." >&2
	$(dirname ${0})/../tools/generate-unicode-org-mappings-table.sh "${I}" > "$(dirname ${0})/${NAME}.lua"
done
