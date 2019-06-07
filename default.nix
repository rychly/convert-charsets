# this Nix script is utilized to initialize the environment including required dependencies for *-shell.sh script (run) and nix-shell (development)

with import <nixpkgs> {};

let
  env = luaPackages.lua; # or .withPackages(ps: with ps; [ sample_package ]);
in
stdenv.mkDerivation {
  name = "lua-env";
  inherit env;
  buildInputs = [ env ];
  shellHook = ''
    export LUA_CPATH="./?.so;./?/init.so"
    export LUA_PATH="./?.lua;./?/init.lua"
  '';
}
