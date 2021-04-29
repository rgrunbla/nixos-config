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


programs.dconf.enable = true;
services.gnome3.gnome-keyring.enable = true;
services.gnome3.gnome-online-accounts.enable = true;

  system.copySystemConfiguration = true;

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
        ms-vscode.cpptools
        xaver.clang-format
      ]);
      vscode-with-extensions = pkgs.vscode-with-extensions.override {
        vscodeExtensions = extensions;
      };
    in
    [
      openconnect
      # Terminal
      alacritty
      # Sound
      pavucontrol
      # Editors
      libreoffice
      texlive.combined.scheme-full
      # Social
      mattermost-desktop
      mailspring
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
      pdfpc
      # Screen Sharing & Visio
      audacity
      obs-v4l2sink
      obs-wlrobs
      obs-studio
      zoom-us
      skype
      vscode-with-extensions
      teams
      # Nix
      nix-index
      nixfmt
      ccache
      # Network
      bind
      # Dev
      gnumake
      clang
      nixpkgs-fmt
      kvm
      python3
      rustup
      hyperfine
      # GUIs
      gnome3.adwaita-icon-theme
    ];

  fonts.fonts = with pkgs; [
    noto-fonts
    noto-fonts-cjk
    noto-fonts-emoji
    liberation_ttf
    font-awesome
    terminus_font
    aileron
  ];

  specialisation = {
    wayland.configuration =
      {
        system.nixos.tags = [ "wayland" ];

        environment.sessionVariables = {
          MOZ_ENABLE_WAYLAND = "1";
          XDG_CURRENT_DESKTOP = "sway"; # TODO: Do we need this in non-sway setups?
          XDG_SESSION_TYPE = "wayland";
        };

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

      };

    xorg.configuration =
      {
        system.nixos.tags = [ "xorg" ];
        services.xserver = {
          enable = true;

          layout = "fr";
          xkbVariant = "bepo";

          # Enable touchpad support.
          libinput = {
            enable = true;
          };

          desktopManager = {
            xterm.enable = false;
          };

          displayManager = {
            defaultSession = "none+i3";
            lightdm.enable = true;
          };

          windowManager.i3 = {
            enable = true;
            extraPackages = with pkgs; [
              dmenu #application launcher most people use
              i3status # gives you the default i3 status bar
              i3lock #default i3 screen locker
              i3blocks #if you are planning on using i3blocks over i3status
            ];
          };
        };
      };
  };

  networking.firewall.allowedTCPPorts = [ 8010 ];
  services.avahi.enable = true;

  # Early Oom
  services.earlyoom.enable = true;

  services.pipewire.enable = true;

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
    TLP_DEFAULT_MODE = "BAT";
    CPU_SCALING_GOVERNOR_ON_AC = "auto";
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
