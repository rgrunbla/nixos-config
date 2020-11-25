{ config, pkgs, lib, ... }:

{
  imports =
    [
      ../../profiles/common.nix
    ];

  networking = {
    hostName = "auberon";
    domain = "lan";

    firewall.enable = true;
    useDHCP = false;
    usePredictableInterfaceNames = false;

    interfaces.eth0.ipv4.addresses = [{
      address = "10.0.0.3";
      prefixLength = 24;
    }];

    interfaces.eth0.ipv6.addresses = [{
      address = "2001:41d0:1:f45e::4";
      prefixLength = 64;
    }];

    defaultGateway = "10.0.0.1";
    defaultGateway6 = "2001:41d0:1:f45e::2";

    nameservers = [ "10.0.0.2" "2001:41d0:1:f45e::3" ];

    firewall = {
      allowedTCPPorts = [ 80 ];
    };
  };

  services.nginx = {
    enable = true;
    recommendedProxySettings = true;
    virtualHosts."upload.grunblatt.org" = {
      listen = [{ "addr" = "10.0.0.3"; "port" = 80; }];
      root = "/data/upload.grunblatt.org";
    };
  };

  services.matterbridge = {
    enable = true;
    configPath = "/etc/matterbridge.toml";
    user = "nginx";
    group = "nginx";
  };

  environment.etc = {
    "matterbridge.toml" = {
      mode = "0660";
      source = ../../nixos-secrets/auberon/matterbridge.toml;
      group = "nginx";
      user = "nginx";
    };
  };

  # compatible NixOS release
  system.stateVersion = "20.09";
}
