{ config, pkgs, lib, writeShellScriptBin, ... }:
let update_website = pkgs.writeShellScriptBin "update_website"
  ''
    cd /data/
    REPO="Blog"
    REPO_URL="git@github.com:rgrunbla/Blog.git"
    KEY_PATH="/etc/laconia_deploy.key"

    if [ ! -d $REPO ]
      then
        ssh-agent bash -c "ssh-add $KEY_PATH; git clone --recursive $REPO_URL"
      else
        cd $REPO
        ssh-agent bash -c "ssh-add $KEY_PATH; git pull"
    fi

    cd $REPO;
    make html;
    cp -r output/* /data/remy.grunblatt.org/;
  '';
in
{
  imports =
    [
      ../../profiles/common.nix
    ];

  networking = {
    hostName = "laconia";
    domain = "lan";

    firewall.enable = true;
    useDHCP = false;
    usePredictableInterfaceNames = false;

    interfaces.eth0.ipv4.addresses = [{
      address = "10.0.0.4";
      prefixLength = 24;
    }];

    interfaces.eth0.ipv6.addresses = [{
      address = "2001:41d0:1:f45e::5";
      prefixLength = 64;
    }];

    defaultGateway = "10.0.0.1";
    defaultGateway6 = "2001:41d0:1:f45e::2";

    nameservers = [ "10.0.0.2" "2001:41d0:1:f45e::3" ];

    firewall = {
      allowedTCPPorts = [ 80 9000 ];
    };
  };

  programs.ssh.knownHosts = {
    github = {
      hostNames = [ "github.com" ];
      publicKey = "ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEAq2A7hRGmdnm9tUDbO9IDSwBK6TbQa+PXYPCPy6rbTrTtw7PHkccKrpp0yVhp5HdEIcKr6pLlVDBfOLX9QUsyCOV0wzfjIJNlGEYsdlLJizHhbn2mUjvSAHQqZETYP81eFzLQNnPHt4EVVUh7VfDESU84KezmD5QlWpXLmvU31/yMf+Se8xhHTvKSCZIFImWwoG6mbUoWf9nzpIoaSjB+weqqUUmpaaasXVal72J+UX2B+2RPW3RcT0eOzQgqlJL3RKrTJvdsjE3JEAvGq3lGHSZXy28G3skua2SmVi/w4yCE6gbODqnTWlg7+wC604ydGXA8VJiS5ap43JXiUFFAaQ==";
    };
  };


  environment.systemPackages = with pkgs; [
    update_website
  ];

  # Define systemd service for betterlockscreen to run on suspend
  systemd.services.webhook = {
    enable = true;
    description = "Launch webhook at the start";
    serviceConfig = {
      User = "nginx";
      Type = "exec";
      ExecStart = ''${pkgs.webhook}/bin/webhook -hooks /etc/hooks.json -verbose'';
      Restart = "on-failure";
    };
    wantedBy = ["multi-user.target"];
    path = [ pkgs.openssh pkgs.python38Packages.pelican pkgs.git pkgs.bash pkgs.gnumake update_website ];
  };


  environment.etc = {
    "laconia_deploy.key" = {
      mode = "0600";
      source = ../../nixos-secrets/laconia_deploy.key;
      group = "nginx";
      user = "nginx";
    };
    "laconia_deploy.pub" = {
      mode = "0660";
      source = ../../nixos-secrets/laconia_deploy.pub;
      group = "nginx";
      user = "nginx";
    };
    "hooks.json" = {
      mode = "0660";
      source = ../../nixos-secrets/laconia_hooks.json;
      group = "nginx";
      user = "nginx";
    };
  };

  system.activationScripts = {
    website_setup = {
      text = "if [ ! -d '/data/remy.grunblatt.org' ] ; then mkdir -p '/data/remy.grunblatt.org/'; fi; chown nginx:nginx -R /data/;";
      deps = [ ];
    };
  };

  services.nginx = {
    enable = true;
    recommendedProxySettings = true;
    virtualHosts."remy.grunblatt.org" = {
      listen = [{ "addr" = "10.0.0.4"; "port" = 80; }];
      root = "/data/remy.grunblatt.org";
    };
  };

  # compatible NixOS release
  system.stateVersion = "20.09";
}
