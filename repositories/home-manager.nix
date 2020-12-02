{ config, pkgs, ... }:

{  
  imports = [
    (import "${builtins.fetchTarball https://github.com/nix-community/home-manager/archive/release-20.09.tar.gz}/nixos")
  ];
}
