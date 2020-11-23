{ config, pkgs, lib, ... }:

{
  networking.wg-quick.interfaces = {
    wg0 = {
      address = [ "10.13.37.2/24" "2001:41d0:0001:f45e:8000::2/65" ];
      dns = [ "10.13.37.1" "2001:41d0:0001:f45e:8000::1" ];
      privateKeyFile = "${../nixos-secrets/wireguard_sauron_private.key}";

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
}
