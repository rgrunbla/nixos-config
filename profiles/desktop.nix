{ config, pkgs, lib, ... }:

{

  imports = [
    ../users/remy/base.nix
    ../services/systemd-boot.nix
    ../services/wpa_supplicant.nix
    ../services/redshift.nix
    ../services/netevent.nix
    ../repositories/home-manager.nix
    ../repositories/nur.nix
  ];

  # Auto Upgrade
  system.autoUpgrade.enable = true;

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
    youtube-dl
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
    # Nix
    nix-index
    nixfmt
    # Network
    bind
    # Dev
    python3
    rustup
    hyperfine
    # GUIs
    gnome3.adwaita-icon-theme
    nerdfonts
  ];


  environment.sessionVariables = {
    MOZ_ENABLE_WAYLAND = "1";
    XDG_CURRENT_DESKTOP = "sway"; # TODO: Do we need this in non-sway setups?
    XDG_SESSION_TYPE = "wayland";
  };


  services.pipewire.enable = true;

  xdg = {
    portal = {
      enable = true;
      extraPortals = with pkgs; [
        xdg-desktop-portal-wlr
        xdg-desktop-portal-gtk
      ];
      gtkUsePortal = true;
    };
  };

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

  boot.extraModulePackages = with config.boot.kernelPackages; [
    v4l2loopback # Obs Screen Sharing
    acpi_call # Power Management
  ];

  boot.kernelModules = [
    "v4l2loopback" # Obs Screen Sharing
    "acpi_call" # Power Management
  ];

  # Power Management
  services.tlp.enable = true;
  powerManagement.powertop.enable = true;
  services.logind.extraConfig = "HandlePowerKey=suspend";

  # Kernel Customization
  #boot.kernelPatches = [ {
  #  name = "wifi-debug";
  #  patch = null;
  #  extraConfig = ''
  #          MAC80211_DEBUGFS y
  #        '';
  #  } ];

}
