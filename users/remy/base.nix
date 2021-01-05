{ config, pkgs, lib, ... }: {
  imports = [ ../../nixos-secrets/common/remy.nix ];

  users.users.remy = {
    isNormalUser = true;
    extraGroups =
      [ "wheel" "wireshark" "uinput" ]; # Enable ‘sudo’ for the user.
  };

  # HackRf
  services.udev.extraRules = ''
    SUBSYSTEM=="usb",ATTRS{idVendor}=="1d50",ATTRS{idProduct}=="6089",OWNER="remy"
  '';

  # Home-Manager
  home-manager.useUserPackages = true;
  home-manager.users.remy = {
    programs.git = {
      enable = true;
      userName = "Rémy Grünblatt";
      userEmail = "remy@grunblatt.org";
    };

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

    # Browser settings
    programs.browserpass = {
      enable = true;
      browsers = [ "firefox" ];
    };

    programs.firefox.enable = true;
    programs.firefox.package = pkgs.firefox-wayland;
    programs.firefox.extensions = with pkgs.nur.repos.rycee.firefox-addons; [
      ublock-origin
      browserpass
      buster-captcha-solver
      clearurls
      i-dont-care-about-cookies
      octotree
    ];

    programs.firefox.profiles =
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

    # Sway
    wayland.windowManager.sway = {
      extraConfig = ''
      seat seat0 xcursor_theme "Breeze"
      exec_always gsettings set org.gnome.desktop.interface cursor-theme "Breeze"
      '';
      enable = true;
      wrapperFeatures.gtk = true;
      config.output = {
        eDP-1 = { pos = "0 0 res 3840x2160 scale 1.5"; };
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
            "${modifier}+Shift+parenleft" =  "move container to workspace number 4";
            "${modifier}+Shift+parenright" =  "move container to workspace number 5";
            "${modifier}+Shift+at" = "move container to workspace number 6";
            "${modifier}+Shift+plus" = "move container to workspace number 7";
            "${modifier}+Shift+minus" = "move container to workspace number 8";
            "${modifier}+Shift+slash" = "move container to workspace number 9";
            "${modifier}+Shift+asterisk" = "move container to workspace number 10";
          };
    };

    home.packages = with pkgs;
      [
        terminus_font
        swaylock
        swayidle
        wl-clipboard
        mako
        alacritty
        bemenu
      ];
  };
}
