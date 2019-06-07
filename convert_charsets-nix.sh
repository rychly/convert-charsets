#!/usr/bin/env nix-shell
--[[
#!nix-shell -i lua default.nix
# ^ because the following inline Nix expression cannot include ./?.lua and ./?/init.lua in LUA_PATH: #!nix-shell -i lua -p "luaPackages.lua.withPackages(ps: with ps; [ sample_package ])"
--]]

local convert_charsets = require("convert_charsets")
os.exit(convert_charsets.main(arg))
