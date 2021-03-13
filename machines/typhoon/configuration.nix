{ config, pkgs, ... }:

{
  imports =
    [
      /etc/nixos/hardware-configuration.nix
      ../../profiles/hardware.nix
      ../../profiles/common.nix
      ../../profiles/desktop.nix
      ../../profiles/work.nix
    ];

  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot/efi";
  boot.loader.grub = {
    enable = true;
    device = "nodev";
    version = 2;
    efiSupport = true;
    enableCryptodisk = true;
  };

  boot.initrd = {
    luks.devices."root" = {
      device = "/dev/disk/by-uuid/49fa0e71-7313-4563-82fd-6b241b24762b"; # UUID for /dev/nvme01np2 
      preLVM = true;
      keyFile = "/keyfile0.bin";
      allowDiscards = true;
    };
    secrets = {
      # Create /mnt/etc/secrets/initrd directory and copy keys to it
      "keyfile0.bin" = "/etc/secrets/initrd/keyfile0.bin";
    };
  };

  # no access time and continuous TRIM for SSD
  fileSystems."/".options = [ "noatime" "discard" ];

  # Update intel microcode
  hardware.cpu.intel.updateMicrocode = true;

  networking = {
    hostName = "typhoon";
    domain = "lan";

    firewall.enable = true;
    wireless.enable = true;
    useDHCP = true;
  };

  # Wireguard
  networking.wg-quick.interfaces = {
    wg0 = {
      address = [ "10.13.37.2/24" "2001:41d0:0001:f45e:8000::2/65" ];
      dns = [ "10.13.37.1" "2001:41d0:0001:f45e:8000::1" ];
      privateKeyFile = "${../../nixos-secrets/typhoon/wireguard_private.key}";

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
