{ pkgs ? import (builtins.fetchGit {
      name = "nixpkgs-with-kicad5";
      url = "https://github.com/NixOS/nixpkgs/";
      ref = "refs/heads/nixpkgs-unstable";
      rev = "89f196fe781c53cb50fef61d3063fa5e8d61b6e5";
  }) {}
, tag ? "latest"
}:

with pkgs;
let
  kibot = callPackage ./pkgs/kibot { use-vglrun = false; };
  pcbdraw = callPackage ./pkgs/pcbdraw {};
  recordmydesktop = callPackage ./pkgs/recordmydesktop {};
in
pkgs.dockerTools.buildLayeredImage {
  inherit tag;

  name = "rgoulter/kibot";

  extraCommands = "mkdir -m 0777 tmp";

  contents = [
    bash
    coreutils
    fluxbox
    kibot
    pcbdraw
    recordmydesktop
    turbovnc
    virtualgl
    wmctrl
    x11vnc
    xclip
    xdotool
    xorg.xkbcomp
  ];

  config = {
    Env = [
      "KICAD_SYMBOL_DIR=${kicad.libraries.symbols}/share/kicad/library"
    ];
  };
}
