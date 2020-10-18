{ config, pkgs, ... }:

{
  imports =
    [
      /etc/nixos/hardware-configuration.nix
      ../../profiles/hardware.nix
      ../../profiles/common.nix
      ../../profiles/desktop.nix
    ];

  boot.loader.grub.device = "/dev/sda";

  # no access time and continuous TRIM for SSD
  fileSystems."/".options = [ "noatime" "discard" ];

  # Update intel microcode
  hardware.cpu.intel.updateMicrocode = true;

  # use latest kernel to have best performance
  boot.kernelPackages = pkgs.linuxPackages_latest;

  networking = {
    hostName = "sauron";
    domain = "lan";

    firewall.enable = true;
    wireless.enable = true;
    useDHCP = true;
  };

  # compatible NixOS release
  system.stateVersion = "unstable";
}
