#!/usr/bin/env nix-shell
--[[
#!nix-shell -i lua -p lua51Packages.lua
--]]

convert_charsets = require("convert_charsets")
os.exit(convert_charsets.main(arg))