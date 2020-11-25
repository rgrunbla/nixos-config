{ config, pkgs, lib, ... }:

let
  pubkeys = import ./pubkeys.nix;
in
{
  services.openssh = {
    enable = true;
    permitRootLogin = "no";
    passwordAuthentication = lib.mkDefault false;
  };

  users.extraUsers.root.openssh.authorizedKeys.keys = pubkeys.remy ;
  users.extraUsers.remy.openssh.authorizedKeys.keys = pubkeys.remy ;
}
