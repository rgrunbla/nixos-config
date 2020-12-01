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
        ExecStart = let
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
        in "${
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
    in {
      home = {
        id = 0;
        settings = defaultSettings ;
      };
    };
  };
}
