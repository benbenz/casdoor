let
  nixpkgs = fetchTarball "https://github.com/NixOS/nixpkgs/tarball/nixos-24.05";
  pkgs = import nixpkgs { config = {}; overlays = []; };
in

pkgs.mkShell {
  buildInputs = [
    pkgs.git
    pkgs.nodejs_18
    pkgs.certbot
    pkgs.jre
    pkgs.python39
    pkgs.openssl
    pkgs.postgresql
    pkgs.go_1_22
    pkgs.yarn
    pkgs.delve
    pkgs.pgbouncer
  ];
}
