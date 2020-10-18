{ config, pkgs, lib, ... }:

{
  imports =
    [
      ../services/systemd-boot.nix
      ../services/localization.nix
      ../services/nix.nix
      #../services/ssh.nix
      #../services/ntp.nix
      #../services/dns.nix
    ];

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
    mtr
    #siege
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
    #restic
    ripgrep
    gopass
    #micro
    #tealdeer
    screen
    tree
    dfc
    pwgen
    jq
    yq
    vim
    tmux
    _0x0
    gitAndTools.gitFull
  ];

  programs.bash.enableCompletion = true;

  environment.variables = {
    "EDITOR" = "vim";
    "VISUAL" = "code";
  };

  # not used
  documentation.enable = false;
  documentation.nixos.enable = false;
  #documentation.man.enable = false;
  documentation.info.enable = false;
  documentation.doc.enable = false;

  # copy the system configuration into nix-store
  system.copySystemConfiguration = true;
}
