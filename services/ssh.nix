{ config, pkgs, lib, ... }:

let
  pubkey = import ./pubkey.nix;
in
{
  services.openssh = {
    enable = true;
    permitRootLogin = "no";
    passwordAuthentication = lib.mkDefault false;
  };

  users.extraUsers.root.openssh.authorizedKeys.keys = lib.mkDefault [ pubkey.remy ];
  users.extraUsers.remy.openssh.authorizedKeys.keys = lib.mkDefault [ pubkey.remy ];
}
