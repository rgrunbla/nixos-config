{ config, pkgs, ... }:

{
  imports =
    [
      ../../profiles/common.nix
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
    defaultGateway = "10.0.0.1";
    nameservers = [ "8.8.8.8" ];
  };

  networking.firewall.allowedTCPPorts = [ ];
}
