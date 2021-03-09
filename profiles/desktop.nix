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
  environment.systemPackages = with pkgs;
    let
      extensions = (with pkgs.vscode-extensions; [
        vscode-extensions.ms-vsliveshare.vsliveshare
        vscode-extensions.matklad.rust-analyzer
        bbenoist.Nix
        ms-python.python
        jnoortheen.nix-ide
      ]);
      vscode-with-extensions = pkgs.vscode-with-extensions.override {
        vscodeExtensions = extensions;
      };
    in
    [
      # Terminal
      alacritty
      # Sound
      pavucontrol
      # Editors
      libreoffice
      texlive.combined.scheme-full
      # Social
      mattermost-desktop
      thunderbird
      signal-desktop
      # Media & Images
      grim
      inkscape
      gimp
      imv
      vlc
      mpv
      youtube-dl
      # Web
      torsocks
      chromium
      # PDFs
      evince
      # Development
      gnumake
      nixpkgs-fmt
      kvm
      # Screen Sharing & Visio
      obs-studio
      zoom-us
      vscode-with-extensions
      teams
      # Nix
      nix-index
      nixfmt
      ccache
      # Network
      bind
      # Dev
      python3
      rustup
      hyperfine
      gcc
      # GUIs
      gnome3.adwaita-icon-theme
      nerdfonts
    ];

  environment.sessionVariables = {
    MOZ_ENABLE_WAYLAND = "1";
    XDG_CURRENT_DESKTOP = "sway"; # TODO: Do we need this in non-sway setups?
    XDG_SESSION_TYPE = "wayland";
  };

  networking.firewall.allowedTCPPorts =[8010];
  services.avahi.enable = true;
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
  services.logind.extraConfig = "HandlePowerKey=suspend";

  services.tlp.settings = {
        USB_AUTOSUSPEND = 0;
        TLP_DEFAULT_MODE="BAT";
        CPU_SCALING_GOVERNOR_ON_AC="auto";
  };

  # CCache
  programs.ccache.enable = true;

  # Kernel Customization
  #boot.kernelPatches = [ {
  #  name = "wifi-debug";
  #  patch = null;
  #  extraConfig = ''
  #          MAC80211_DEBUGFS y
  #        '';
  #  } ];
}
