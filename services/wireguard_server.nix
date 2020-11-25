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
        allowedUDPPorts = [ 53 51820 ];
        allowedTCPPorts = [ 53 ];
      };

      wireguard = {
        interfaces = {
          wg0 = {
            ips = [ "10.13.37.1/24" "2001:41d0:0001:f45e:8000::1" ];

            listenPort = 51820;

            postSetup = ''
              ${pkgs.iptables}/bin/iptables -A FORWARD -i wg0 -j ACCEPT
              ${pkgs.iptables}/bin/iptables -t nat -A POSTROUTING -s 10.13.37.0/24 -o eth0 -j MASQUERADE
              ${pkgs.iptables}/bin/ip6tables -A FORWARD -i wg0 -j ACCEPT
              ${pkgs.iptables}/bin/ip6tables -t nat -A POSTROUTING -s 2001:41d0:0001:f45e:8000::1/65 -o eth0 -j MASQUERADE
            '';

            postShutdown = ''
              ${pkgs.iptables}/bin/iptables -D FORWARD -i wg0 -j ACCEPT
              ${pkgs.iptables}/bin/iptables -t nat -D POSTROUTING -s 10.13.37.0/24 -o eth0 -j MASQUERADE
              ${pkgs.iptables}/bin/ip6tables -D FORWARD -i wg0 -j ACCEPT
              ${pkgs.iptables}/bin/ip6tables -t nat -D POSTROUTING -s 2001:41d0:0001:f45e:8000::1/65 -o eth0 -j MASQUERADE
            '';

            privateKeyFile = "${../nixos-secrets/gate/wireguard_private.key}";

            peers = [
              {
                # Sauron
                publicKey = "4xcf/dLyOix/B7ME9XpbWIbDbF4x4+E30dc1vIm7dRY=";
                allowedIPs = [ "10.13.37.2/32" "2001:41d0:0001:f45e:8000::2/128" ];
              }
              {
                # Rocinante
                publicKey = "viz7+4zccEbq1axXjly99Tj2Kbk3S1CCRdl853hn1iw=";
                allowedIPs = [ "10.13.37.3/32" "2001:41d0:0001:f45e:8000::3/128" ];
              }
            ];
          };
        };
      };
    };
}
