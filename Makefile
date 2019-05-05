PREFIX=/usr/local
LUA_BINDIR=$(PREFIX)/bin
LUA_LIBDIR=$(PREFIX)/lib/lua/5.1
LUA_LUADIR=$(subst /lib/,/share/,$(LUA_LIBDIR))
LUA_CONFDIR=$(PREFIX)/etc

all:

install:
	mkdir -p $(LUA_LUADIR)/convert_charsets
	cp convert_charsets.lua $(LUA_LUADIR)
	cp convert_charsets/*.lua $(LUA_LUADIR)/convert_charsets
	mkdir -p $(LUA_BINDIR)
	cp convert_charsets-shell.sh $(LUA_BINDIR)/convert-charsets
