{ config, pkgs, lib, options, ... }:

{

  nixpkgs.overlays = [
    ( import ../overlays/packages.nix )
    ( import (builtins.fetchTarball "https://github.com/colemickens/nixpkgs-wayland/archive/master.tar.gz") )
  ];

  imports =
    [
      ../services/localization.nix
      ../services/nix.nix
      ../services/ssh.nix
      ../nixos-secrets/common/remy.nix
      ../users/root/base.nix
      ../cachix.nix
    ];

  nix.trustedUsers = [ "root" "remy" ];

  # mount tmpfs on /tmp
  boot.tmpOnTmpfs = lib.mkDefault true;

  # install basic packages
  environment.systemPackages = with pkgs; [
    htop
    iotop
    iftop
    wget
    curl
    tcpdump
    telnet
    whois
    gnumake
    mtr
    file
    lsof
    inotify-tools
    strace
    gdb
    xz
    lz4
    zip
    unzip
    rsync
    ripgrep
    gopass
    tree
    dfc
    pwgen
    vim
    tmux
    _0x0
    gitAndTools.gitFull
    linuxHeaders
    cachix
   # linuxPackages.bpftrace
    linuxPackages.bcc
  ];

  programs.bash.enableCompletion = true;

  environment.variables = {
    "EDITOR" = "vim";
    "VISUAL" = "code --wait";
  };

  # not used
  documentation.enable = false;
  documentation.nixos.enable = false;
  documentation.man.enable = false;
  documentation.info.enable = false;
  documentation.doc.enable = false;

  # use latest kernel to have best performance

  boot.kernelPackages = pkgs.linuxPackages_latest;

  # Enably timesyncd
  services.timesyncd.enable = lib.mkDefault true;

  programs.ssh.knownHosts = {
    github = {
      hostNames = [ "github.com" ];
      publicKey = "ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEAq2A7hRGmdnm9tUDbO9IDSwBK6TbQa+PXYPCPy6rbTrTtw7PHkccKrpp0yVhp5HdEIcKr6pLlVDBfOLX9QUsyCOV0wzfjIJNlGEYsdlLJizHhbn2mUjvSAHQqZETYP81eFzLQNnPHt4EVVUh7VfDESU84KezmD5QlWpXLmvU31/yMf+Se8xhHTvKSCZIFImWwoG6mbUoWf9nzpIoaSjB+weqqUUmpaaasXVal72J+UX2B+2RPW3RcT0eOzQgqlJL3RKrTJvdsjE3JEAvGq3lGHSZXy28G3skua2SmVi/w4yCE6gbODqnTWlg7+wC604ydGXA8VJiS5ap43JXiUFFAaQ==";
    };
  };
}
