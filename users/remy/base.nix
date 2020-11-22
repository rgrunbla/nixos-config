{ config, pkgs, lib, ... }:
{
  imports =
    [
      ../../nixos-secrets/remy.nix
    ];

  users.users.remy = {
    isNormalUser = true;
    extraGroups = [ "wheel" "wireshark" "uinput"]; # Enable ‘sudo’ for the user.
  };

  services.udev.extraRules = ''
  SUBSYSTEM=="usb",ATTRS{idVendor}=="1d50",ATTRS{idProduct}=="6089",OWNER="remy"
  '';
  #  home-manager.useUserPackages = true;
  #  home-manager.useGlobalPkgs = true;
}
