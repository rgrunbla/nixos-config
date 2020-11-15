{ config, pkgs, lib, ... }:

{
  imports =
    [
      ../services/localization.nix
      ../services/nix.nix
      ../services/ssh.nix
      ../users/remy/base.nix
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
  ];

  programs.bash.enableCompletion = true;

  environment.variables = {
    "EDITOR" = "vim";
    "VISUAL" = "code --wait";
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
