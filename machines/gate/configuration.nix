{ config, pkgs, lib, ... }:

{
  imports =
    [
      ../../profiles/common.nix
      ../../services/wireguard_server.nix
    ];

  # use latest kernel to have best performance
  boot.kernelPackages = pkgs.linuxPackages_latest;

  services.timesyncd.enable = lib.mkDefault true;

  networking = {
    hostName = "gate";
    domain = "lan";

    firewall.enable = true;
    useDHCP = false;
    usePredictableInterfaceNames = false;

    interfaces.eth0.ipv4.addresses = [{
      address = "10.0.0.2";
      prefixLength = 24;
    }];

    interfaces.eth0.ipv6.addresses = [{
      address = "2001:41d0:1:f45e::3";
      prefixLength = 64;
    }];

    defaultGateway = "10.0.0.1";
    defaultGateway6 = "2001:41d0:1:f45e::2";
    nameservers = [ "8.8.8.8" ];
  };

  networking.firewall.allowedTCPPorts = [ ];
}
