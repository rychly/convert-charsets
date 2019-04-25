#!/usr/bin/env bash

for I in $(dirname "${0}")/*/generate.sh; do
	${I}
done
