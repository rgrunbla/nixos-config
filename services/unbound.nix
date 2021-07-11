{ config, pkgs, lib, ... }:

{
  services.unbound = {
    enable = true;
    allowedAccess = [
      "127.0.0.0/24"
      # VMs
      "10.0.0.0/24"
      "2001:41d0:1:f45e::1/65"
      # Wireguard
      "10.13.37.0/24"
      "2001:41d0:1:f45e:8000::1/65"
    ];
    interfaces = [
      "127.0.0.1"
      "::1"
      "10.0.0.2"
      "10.13.37.1"
      "2001:41d0:1:f45e::3"
      "2001:41d0:1:f45e:8000::1"
    ];
  };
}
