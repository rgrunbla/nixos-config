{ config, pkgs, lib, ... }:

{

  imports = [
    ../users/remy/base.nix
    ../services/wpa_supplicant.nix
    ../services/sway.nix
    ../services/redshift.nix
    ../services/netevent.nix
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
    ungoogled-chromium
    torbrowser
    torsocks
    # PDFs
    evince
    # Development
    gnumake
    nixpkgs-fmt
    # Screen Sharing & Visio
    obs-studio
    zoom-us
    # FIXME
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

  # Screen Sharing
  services.pipewire.enable = true;
  services.pipewire.socketActivation = true;

  # Chromium
  programs.chromium = {
    enable = true;
    # Imperatively installed extensions will seamlessly merge with these.
    # Removing extensions here will remove them from chromium, no matter how
    # they were installed.
    defaultSearchProviderSearchURL = "https://google.fr/?q={searchTerms}";

    extensions = [
      "naepdomgkenhinolocfifgehidddafch" # browserpass-ce
      "cjpalhdlnbpafiamejdnhcphjbkeiagm" # ublock origin
    ];
  };


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
