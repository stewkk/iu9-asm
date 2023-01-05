{ pkgs ? import (fetchTarball "https://github.com/NixOS/nixpkgs/archive/fd26d2bd8d0e4f3248a3cca0f405fb60117ab988.tar.gz") {} }:

with pkgs;

mkShell {
  buildInputs = [
    gnumake
    yasm
    gdb
    gcc
    nasmfmt
    python311

    figlet
    # keep this line if you use bash
    bashInteractive
  ];

  shellHook = ''
    echo iu9-ASM | figlet
  '';
}
