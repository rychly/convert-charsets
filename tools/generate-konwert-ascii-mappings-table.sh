#!/usr/bin/env bash

URL="http://ftp.cz.debian.org/debian/pool/main/k/konwert/konwert-filters_1.8-13_all.deb"

if [[ "${1}" = "--help" ]]; then
	echo "Usage:	${0}" >&2
	echo "Generate Lua source of UTF-8 to ASCII mapping table from ${URL}" >&2
	exit 1
fi

WORKDIR=$(mktemp -d /tmp/generate-konwert-ascii-mappings-table.workdir.XXXXXXXXXX)
trap "rm -rf '${WORKDIR}'" EXIT

FILES="./usr/share/konwert/aux/UTF8-ascii ./usr/share/konwert/aux/UTF8-ascii1"

wget -O "${WORKDIR}/konwert-filters.deb" "${URL}" \
&& ar p "${WORKDIR}/konwert-filters.deb" data.tar.xz \
| tar -xC "${WORKDIR}" --xz ${FILES}

echo "local mapping_UTF_8_to_ASCII = {"

cd "${WORKDIR}"

cat ${FILES} | while read LINE; do
	CHAR_UTF8=$(echo "${LINE}" | cut -f 1)
	STR_ASCII=$(echo "${LINE}" | cut -f 2)
	echo "	\"${CHAR_UTF8}\" = \"${STR_ASCII}\","
done

cd - >/dev/null

echo "}"
