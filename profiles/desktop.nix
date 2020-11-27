{ config, pkgs, lib, ... }:

{

  imports = [
    ../services/systemd-boot.nix
    ../services/wpa_supplicant.nix
    ../services/sway.nix
    ../services/redshift.nix
    ../services/netevent.nix
    ../repositories/home-manager.nix
    ../repositories/nur.nix
  ];


  nixpkgs.config.allowUnfree = true;

  # install packages
  environment.systemPackages = with pkgs; [
    # Terminal
    alacritty
    # Sound
    pavucontrol
    # Editors
    libreoffice
    texlive.combined.scheme-full
    vscode
    # Social
    mattermost-desktop
    thunderbird
    # Media & Images
    grim
    inkscape
    gimp
    imv
    mpv
    # Web
    torsocks
    # PDFs
    evince
    # Development
    gnumake
    nixpkgs-fmt
    kvm
    # Screen Sharing & Visio
    obs-studio
    zoom-us
    # FIXME
    nix-index
    gnome3.adwaita-icon-theme
  ];

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio = {
    enable = true;
    package = pkgs.pulseaudioFull;
  };

  programs.browserpass.enable = true;
  programs.wireshark.enable = true;

  # Enable pinentry
  programs.gnupg.agent.enable = true;
  programs.gnupg.agent.pinentryFlavor = "gnome3";

  # Bluetooth
  hardware.bluetooth.enable = true;

  # Printing
  services.printing.enable = true;

  # Graphical User Environment
  hardware.opengl.enable = true;

  # Prevent shutdown when pressing the power button
  services.logind.extraConfig =
    "HandlePowerKey=suspend"
  ;

  # Obs Screen Sharing
  boot.extraModulePackages = [
    config.boot.kernelPackages.v4l2loopback
  ];

  boot.kernelModules = [
    "v4l2loopback"
  ];

  # Kernel Customization
  #boot.kernelPatches = [ {
  #  name = "wifi-debug";
  #  patch = null;
  #  extraConfig = ''
  #          MAC80211_DEBUGFS y
  #        '';
  #  } ];


}
