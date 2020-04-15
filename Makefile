PREFIX=/usr/local
LUA_BINDIR=$(PREFIX)/bin
LUA_LIBDIR=$(PREFIX)/lib/lua/5.1
LUA_LUADIR=$(subst /lib/,/share/,$(LUA_LIBDIR))
LUA_CONFDIR=$(PREFIX)/etc

all:

install:
	mkdir -p $(LUA_LUADIR)/convert-charsets
	cp convert-charsets.lua $(LUA_LUADIR)
	cp convert-charsets/*.lua $(LUA_LUADIR)/convert-charsets
	mkdir -p $(LUA_BINDIR)
	cp convert-charsets.sh $(LUA_BINDIR)/convert-charsets
