{ config, pkgs, ... }:

{
  imports =
    [
      /etc/nixos/hardware-configuration.nix
      ../../profiles/hardware.nix
      ../../profiles/common.nix
      ../../profiles/desktop.nix
      ../../services/wireguard_client.nix
    ];

  boot.loader.grub.device = "/dev/sda";

  # no access time and continuous TRIM for SSD
  fileSystems."/".options = [ "noatime" "discard" ];

  # Update intel microcode
  hardware.cpu.intel.updateMicrocode = true;

  networking = {
    hostName = "sauron";
    domain = "lan";

    firewall.enable = true;
    wireless.enable = true;
    useDHCP = true;
  };

  # compatible NixOS release
  system.stateVersion = "20.09";
}
