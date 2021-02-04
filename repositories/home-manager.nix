{ config, pkgs, ... }:

{  
  imports = [
    (import "${builtins.fetchTarball https://github.com/nix-community/home-manager/archive/master.tar.gz}/nixos")
  ];
}
