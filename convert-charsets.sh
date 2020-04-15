#!/usr/bin/env lua

-- set LUA_PATH and LUA_CPATH to load also local modules
local prefix_path = '.';
package.path = ('%s/?.lua;%s/?/init.lua;%s'):format(prefix_path, prefix_path, package.path)
package.cpath = ('%s/?.so;%s/?/init.so;%s'):format(prefix_path, prefix_path, package.cpath)

local convert_charsets = require("convert-charsets")
os.exit(convert_charsets.main(arg))
