{ config, pkgs, lib, ... }:

{
  # Enable Wireguard
  networking.wireguard.interfaces = {
    # "wg0" is the network interface name. You can name the interface arbitrarily.
    wg0 = {
      # Determines the IP address and subnet of the client's end of the tunnel interface.
      ips = [ "10.13.37.2/24" "2001:41d0:0001:f45e:8000::2/65" ];

      # Path to the private key file.
      privateKeyFile = "${../nixos-secrets/wireguard_sauron_private.key}";

      allowedIPsAsRoutes = false;

      peers = [
        # For a client configuration, one peer entry for the server will suffice.
        {
          # Public key of the server (not a file path).
          publicKey = "iqk2Yxf8aKi6vTRsDMOuwAnOGtPGLIZEIUNegyMSgn0=";

          allowedIPs = [ "0.0.0.0/0" "::/0" ];

          # Set this to the server IP and port.
          endpoint = "91.121.179.94:51820";

          # Send keepalives every 25 seconds. Important to keep NAT tables alive.
          persistentKeepalive = 25;
        }
      ];
    };
  };
}
