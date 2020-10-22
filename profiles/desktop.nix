{ config, pkgs, lib, ... }:

{

  imports = [
    ../users/remy/base.nix
    ../services/wpa_supplicant.nix
    ../services/sway.nix
    ../services/redshift.nix
    ../services/netevent.nix
  ];

  nixpkgs.config = {
    allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
      "vscode"
    ];
  };

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
    firefox-wayland
    torbrowser
    torsocks
    # PDFs
    evince
    # Development
    gnumake
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

}
