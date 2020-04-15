let

  name = "convert-charsets";

in
  # Running against custom version of nixpkgs or pkgs would be as simple as running `nix-shell --arg nixpkgs /absolute/path/to/nixpkgs`
  # See https://garbas.si/2015/reproducible-development-environments.html
  { nixpkgs ? import <nixpkgs>, pkgs ? nixpkgs { } }:

pkgs.stdenv.mkDerivation rec {

  inherit name;

  buildInputs = with pkgs; [
    (luaPackages.lua.withPackages(ps: with ps; [ ]))
  ];

  shellHook = ''
    # versions
    echo "# SOFTWARE:" ${builtins.concatStringsSep ", " (map (x: x.name) buildInputs)}
  '';

}
