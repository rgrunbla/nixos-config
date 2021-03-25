{ config, pkgs, lib, ... }: {
  imports = [ ../../nixos-secrets/common/remy.nix ];

  users.users.remy = {
    isNormalUser = true;
    extraGroups =
      [ "wheel" "wireshark" "uinput" "adbusers" "docker" ]; # Enable ‘sudo’ for the user.
  };


  virtualisation.docker.enable = true;

  programs.adb.enable = true;

  # HackRf
  services.udev.extraRules = ''
    SUBSYSTEM=="usb",ATTRS{idVendor}=="1d50",ATTRS{idProduct}=="6089",OWNER="remy"
    # Rule for all ZSA keyboards
    SUBSYSTEM=="usb", ATTR{idVendor}=="3297", GROUP="plugdev"
    # Rule for the Moonlander
    SUBSYSTEM=="usb", ATTR{idVendor}=="3297", ATTR{idProduct}=="1969", GROUP="plugdev"
    # Rule for the Ergodox EZ
    SUBSYSTEM=="usb", ATTR{idVendor}=="feed", ATTR{idProduct}=="1307", GROUP="plugdev"
    # Rule for the Planck EZ
    SUBSYSTEM=="usb", ATTR{idVendor}=="feed", ATTR{idProduct}=="6060", GROUP="plugdev"
    ACTION=="add", SUBSYSTEMS=="usb", ATTRS{idProduct}=="1532", ATTRS{idVendor}=="0046", TEST=="power/control", ATTR{power/control}="on"
    ACTION=="add", SUBSYSTEMS=="usb", ATTRS{idProduct}=="3297", ATTRS{idVendor}=="1969", TEST=="power/control", ATTR{power/control}="on"
  '';

  # Home-Manager
  home-manager.useUserPackages = true;
  specialisation = {
    wayland.configuration =
      {
        # Sway
        home-manager.users.remy = {
          home.packages = with pkgs;
            [
              swaylock
              swayidle
              wl-clipboard
              mako
            ];

          home.sessionVariables = {
            MOZ_ENABLE_WAYLAND = 1;
            XDG_CURRENT_DESKTOP = "sway";
            XDG_SESSION_TYPE = "wayland";
          };

          programs = {
            firefox = {
              package = pkgs.wrapFirefox pkgs.firefox-unwrapped {
                forceWayland = true;
              };
            };

            waybar = {
              enable = true;
              settings = [{
                layer = "top";
                position = "bottom";
                height = 24;
                modules-left = [ "sway/workspaces" "sway/mode" ];
                modules-center = [ "sway/window" ];
                modules-right = [ "custom/stopwatch" "network" "pulseaudio" "battery" "clock" "tray" ];
                modules = {
                  "sway/workspaces" = {
                    format = "{index}";
                  };
                  "custom/stopwatch" = {
                    format = "   {} ";
                    exec = "~/.config/waybar/sw";
                    on-click = "~/.config/waybar/sw";
                    on-click-right = "~/.config/waybar/sw --stop";
                    return-type = "json";
                  };
                  "network" = {
                    format-wifi = " {essid} ({signalStrength}%)";
                    format-ethernet = " {ifname}: {ipaddr}/{cidr}";
                    format-disconnected = "Disconnected ⚠";
                  };
                  "pulseaudio" = {
                    format = "{icon} {volume}%";
                    format-bluetooth = "{icon} {volume}%";
                    format-muted = " 0%";
                    format-icons = {
                      "headphones" = "";
                      "handsfree" = "";
                      "headset" = "";
                      "phone" = "";
                      "portable" = "";
                      "car" = "";
                      "default" = [ "" "" ];
                    };
                  };
                  "battery" = {
                    bat = "BAT0";
                    states = {
                      "warning" = 30;
                      "critical" = 15;
                    };
                    format = "{icon} {capacity}%";
                    format-icons = [ "" "" "" "" "" ];
                  };
                  "clock" = {
                    format = "{:%a %d %b %H:%M:%S}";
                  };
                };
              }];
              # style = (builtins.readFile ./configs/waybar/style.css);
            };
          };

          wayland.windowManager.sway = {
            extraConfig = ''
              exec_always systemctl --user import-environment
            '';
            enable = true;
            wrapperFeatures.gtk = true;
            config.output = {
              eDP-1 = { pos = "0 0 res 3840x2160 scale 1"; };
              DP-5 = { pos = "2560 0 res 3840x2160 scale 1"; };
            };

            config.input = {
              "*" = {
                xkb_layout = "fr";
                xkb_variant = "bepo";
              };

            };

            config.menu = "bemenu-run";
            config.modifier = "Mod4";
            config.terminal = "alacritty";

            config.bars = [ ];

            config.keybindings =
              let modifier = "Mod4";
              in
              lib.mkOptionDefault
                {
                  "${modifier}+quotedbl" = "workspace number 1";
                  "${modifier}+guillemotleft" = "workspace number 2";
                  "${modifier}+guillemotright" = "workspace number 3";
                  "${modifier}+parenleft" = "workspace number 4";
                  "${modifier}+parenright" = "workspace number 5";
                  "${modifier}+at" = "workspace number 6";
                  "${modifier}+plus" = "workspace number 7";
                  "${modifier}+minus" = "workspace number 8";
                  "${modifier}+slash" = "workspace number 9";
                  "${modifier}+asterisk" = "workspace number 10";

                  "${modifier}+Shift+quotedbl" = "move container to workspace number 1";
                  "${modifier}+Shift+guillemotleft" = "move container to workspace number 2";
                  "${modifier}+Shift+guillemotright" = "move container to workspace number 3";
                  "${modifier}+Shift+parenleft" = "move container to workspace number 4";
                  "${modifier}+Shift+parenright" = "move container to workspace number 5";
                  "${modifier}+Shift+at" = "move container to workspace number 6";
                  "${modifier}+Shift+plus" = "move container to workspace number 7";
                  "${modifier}+Shift+minus" = "move container to workspace number 8";
                  "${modifier}+Shift+slash" = "move container to workspace number 9";
                  "${modifier}+Shift+asterisk" = "move container to workspace number 10";
                };
          };
        };
      };
    xorg.configuration = {
      home-manager.users.remy = {
        xsession.windowManager.i3 =
          let
            mod = "Mod4";
          in
          {
            enable = true;

            config = {
              modifier = mod;
              menu = "bemenu-run";
              terminal = "alacritty";
              fonts = [ "DejaVu Sans Mono, FontAwesome 6" ];
              keybindings =
                let modifier = "Mod4";
                in
                lib.mkOptionDefault
                  {
                    "${modifier}+quotedbl" = "workspace number 1";
                    "${modifier}+guillemotleft" = "workspace number 2";
                    "${modifier}+guillemotright" = "workspace number 3";
                    "${modifier}+parenleft" = "workspace number 4";
                    "${modifier}+parenright" = "workspace number 5";
                    "${modifier}+at" = "workspace number 6";
                    "${modifier}+plus" = "workspace number 7";
                    "${modifier}+minus" = "workspace number 8";
                    "${modifier}+slash" = "workspace number 9";
                    "${modifier}+asterisk" = "workspace number 10";

                    "${modifier}+Shift+quotedbl" = "move container to workspace number 1";
                    "${modifier}+Shift+guillemotleft" = "move container to workspace number 2";
                    "${modifier}+Shift+guillemotright" = "move container to workspace number 3";
                    "${modifier}+Shift+parenleft" = "move container to workspace number 4";
                    "${modifier}+Shift+parenright" = "move container to workspace number 5";
                    "${modifier}+Shift+at" = "move container to workspace number 6";
                    "${modifier}+Shift+plus" = "move container to workspace number 7";
                    "${modifier}+Shift+minus" = "move container to workspace number 8";
                    "${modifier}+Shift+slash" = "move container to workspace number 9";
                    "${modifier}+Shift+asterisk" = "move container to workspace number 10";
                  };

              bars = [
                {
                  position = "bottom";
                }
              ];
            };
          };
      };
    };
  };

  home-manager.users.remy = {
    programs.git = {
      enable = true;
      userName = "Rémy Grünblatt";
      userEmail = "remy@grunblatt.org";
    };

    home.stateVersion = "21.03";

    home.file = {
      # SSH
      ".ssh/id_ed25519".source =
        "${../../nixos-secrets/sauron/id_ed22519_private.key}";
      ".ssh/id_ed25519.pub".source =
        "${../../nixos-secrets/sauron/id_ed22519_public.key}";
    };

    home.activation = {
      # Import GPG Keys
      gpg_import = ''
                        ${pkgs.gnupg}/bin/gpg --batch --import ${
        ../../nixos-secrets/common/gnupg_private.key
        }
                        ${pkgs.gnupg}/bin/gpg --batch --import ${
        ../../nixos-secrets/common/gnupg_public.key
        }
      '';
    };

    # Synchronize Passwords
    systemd.user.services.password-synchronization = {
      Unit = { Description = "Synchronize Passwords Store"; };
      Service = {
        Type = "oneshot";
        Environment = "PATH=${pkgs.git}/bin";
        ExecStart =
          let
            script = ''
              #!${pkgs.bash}/bin/bash
              USER="rgrunbla"
              DOMAIN="github.com"
              REPO="passwords"
              REPO_URL="git@$DOMAIN:$USER/$REPO.git"
              REPO_PATH=~/.password-store/

              if [ ! -d $REPO_PATH ]
                then
                  git clone --recursive $REPO_URL $REPO_PATH
                else
                  cd $REPO_PATH
                  git pull
              fi
            '';
          in
          "${
pkgs.writeScriptBin "synchronize-passwords" script
}/bin/synchronize-passwords";
        IOSchedulingClass = "idle";
      };
    };

    systemd.user.timers.password-synchronization = {
      Unit = { Description = "Periodically Synchronize Passwords"; };
      Timer = { OnCalendar = "0/1:00:00"; };
      Install = { WantedBy = [ "timers.target" ]; };
    };

    programs = {
      # Browser settings
      browserpass = {
        enable = true;
        browsers = [ "firefox" ];
      };

      firefox.enable = true;

      firefox.extensions = with pkgs.nur.repos.rycee.firefox-addons; [
        ublock-origin
        browserpass
        buster-captcha-solver
        clearurls
        i-dont-care-about-cookies
        octotree
      ];


      firefox.profiles =
        let defaultSettings = {
          "app.update.auto" = false;
          "browser.startup.homepage" = "https://lobste.rs";
          "browser.shell.checkDefaultBrowser" = false;
          "identity.fxaccounts.account.device.name" = config.networking.hostName;
          "signon.rememberSignons" = false;
        };
        in
        {
          home = {
            id = 0;
            settings = defaultSettings;
          };
        };
    };

    home.packages = with pkgs;
      [
        terminus_font
        alacritty
        bemenu
        deluge
      ];
  };
}
