{ config, pkgs, lib, ... }:

{
  imports =
    [
      ../../profiles/common.nix
      ../../services/wireguard_server.nix
      ../../services/unbound.nix
    ];

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
    nameservers = [ "10.0.0.1" "2001:41d0:1:f45e::2" ];

    firewall = {
      allowedTCPPorts = [ 80 443 ];
    };
  };

  security.acme.email = "remy@grunblatt.org";
  security.acme.acceptTerms = true;

  services.nginx = {
    enable = true;
    recommendedProxySettings = true;
    recommendedTlsSettings = true;

    virtualHosts."upload.grunblatt.org" = {
      enableACME = true;
      forceSSL = true;
      locations."/" = {
        proxyPass = "http://10.0.0.3:80";
      };
    };

  };

  # compatible NixOS release
  system.stateVersion = "20.09";
}
