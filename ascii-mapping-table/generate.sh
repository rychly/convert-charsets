#!/usr/bin/env bash

$(dirname ${0})/../tools/generate-konwert-ascii-mappings-table.sh > $(dirname ${0})/UTF_8.lua
