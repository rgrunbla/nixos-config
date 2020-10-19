{ config, pkgs, lib, ... }:
{
  imports =
    [
      #  <home-manager/nixos>
    ];

  users.users.remy = {
    isNormalUser = true;
    extraGroups = [ "wheel" "wireshark" "uinput"]; # Enable ‘sudo’ for the user.
  };

  #  home-manager.useUserPackages = true;
  #  home-manager.useGlobalPkgs = true;
}
