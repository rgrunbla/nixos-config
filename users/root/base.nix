{ config, pkgs, lib, ... }: {


  imports = [
    ../../repositories/home-manager.nix
  ];

  nix.buildMachines = [
    {
      hostName = "medina.grunblatt.org";
      sshUser = "remy";
      system = "x86_64-linux";
      maxJobs = 8;
      supportedFeatures = ["nixos-test" "benchmark" "big-parallel" "kvm"];
      speedFactor = 2;
    }
    {
      hostName = "citron.lip";
      sshUser = "rgrunbla";
      system = "x86_64-linux";
      maxJobs = 48;
      supportedFeatures = ["big-parallel" "kvm"];
      speedFactor = 4;
    }
  ];

	nix.distributedBuilds = false;
	# optional, useful when the builder has a faster internet connection than yours
	nix.extraOptions = ''
		builders-use-substitutes = true
	'';

  home-manager.users.root = {
    home.activation = {
      # Import GPG Keys
      ssh_keys_import = ''
        mkdir -p ~/.ssh/;
        install -m 400 ${../../nixos-secrets/common/nix_remote_private.key} ~/.ssh/id_rsa_remote_build; 
        install -m 400 ${../../nixos-secrets/common/nix_remote_public.key} ~/.ssh/id_rsa_remote_build.pub ;
      '';
    };

    programs.ssh = {
      enable = true;
      matchBlocks = {
        "gateway" = {
          identityFile = "~/.ssh/id_rsa_remote_build";
          hostname = "ssh.ens-lyon.fr";
          user = "rgrunbla";
          forwardAgent = true;
        };
        "*.dsi-ext" = {
          identityFile = "~/.ssh/id_rsa_remote_build";
          proxyJump = "gateway";
          user = "rgrunbla";
          forwardAgent = true;
        };
        "medina.grunblatt.org" = {
          identityFile = "~/.ssh/id_rsa_remote_build";
          hostname = "medina.grunblatt.org";
          user = "remy";
        };
        "*.lip" = {
          identityFile = "~/.ssh/id_rsa_remote_build";
          proxyJump = "gateway";
          user = "rgrunbla";
        };
      };
    };
  };
}
