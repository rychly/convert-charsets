#!/bin/sh

TABLES="
VENDORS/MICSFT/WINDOWS/CP1250.TXT
ISO8859/8859-2.TXT
"

for I in ${TABLES}; do
	FILE=${I##*/} NAME=${FILE%.*}
	echo "Generating table for ${NAME} ..." >&2
	$(dirname ${0})/../tools/generate-unicode-org-mappings-table.sh "${I}" > "${NAME}.lua"
done
