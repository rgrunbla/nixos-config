{ config, pkgs, lib, ... }:

{
  # Allow IPV4 forwarding, IPV6 forwarding
  boot.kernel.sysctl = {
    "net.ipv4.ip_forward" = true;
    "net.ipv6.conf.all.forwarding" = true;
    "net.ipv6.conf.all.accept_ra" = 2;
  };

  # enable NAT
  networking =
    {
      nat = {
        enable = true;
        externalInterface = "eth0";
        internalInterfaces = [ "wg0" ];
        internalIPs = [ "10.13.37.0/24" ];
        #extraCommands = "ip6tables -w -t nat -A nixos-nat-post -s fd42::/16 -o ens3 -j MASQUERADE";
      };

      firewall = {
        allowedUDPPorts = [ 51820 ];
      };

      wireguard = {
        interfaces = {
          wg0 = {
            # Determines the IP address and subnet of the server's end of the tunnel interface.
            ips = [ "10.13.37.1/24" ];

            # The port that Wireguard listens to. Must be accessible by the client.
            listenPort = 51820;

            # This allows the wireguard server to route your traffic to the internet and hence be like a VPN
            # For this to work you have to set the dnsserver IP of your router (or dnsserver of choice) in your clients
            postSetup = ''
              ${pkgs.iptables}/bin/iptables -t nat -A POSTROUTING -s 10.13.37.0/24 -o eth0 -j MASQUERADE
            '';

            # This undoes the above command
            postShutdown = ''
              ${pkgs.iptables}/bin/iptables -t nat -D POSTROUTING -s 10.13.37.0/24 -o eth0 -j MASQUERADE
            '';

            # Path to the private key file.
            #
            # Note: The private key can also be included inline via the privateKey option,
            # but this makes the private key world-readable; thus, using privateKeyFile is
            # recommended.
            privateKeyFile = "${../nixos-secrets/wireguard_gate_private.key}";

            peers = [
              # List of allowed peers.
              {
                # Sauron
                # Public key of the peer (not a file path).
                publicKey = "4xcf/dLyOix/B7ME9XpbWIbDbF4x4+E30dc1vIm7dRY=";
                # List of IPs assigned to this peer within the tunnel subnet. Used to configure routing.
                allowedIPs = [ "10.13.37.2/32" ];
              }
            ];
          };
        };
      };
    };
}
