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

  networking = {
    hostName = "rocinante";
    domain = "lan";

    firewall.enable = true;
    wireless.enable = true;
    useDHCP = true;
  };

  # Wireguard
  networking.wg-quick.interfaces = {
    wg0 = {
      address = [ "10.13.37.3/24" "2001:41d0:0001:f45e:8000::3/65" ];
      dns = [ "10.13.37.1" "2001:41d0:0001:f45e:8000::1" ];
      privateKeyFile = "${../../nixos-secrets/rocinante/wireguard_private.key}";

      peers = [
        {
          publicKey = "iqk2Yxf8aKi6vTRsDMOuwAnOGtPGLIZEIUNegyMSgn0=";
          allowedIPs = [ "0.0.0.0/0" "::/0" ];
          endpoint = "91.121.179.94:51820";
          persistentKeepalive = 25;
        }
      ];
    };
  };

  # compatible NixOS release
  system.stateVersion = "20.09";
}
