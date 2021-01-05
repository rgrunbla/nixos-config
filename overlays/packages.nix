self: super:
{
  linuxPackages = super.linuxPackages.extend (selfLinuxPkgs: superLinuxPkgs: {
    bpftrace = superLinuxPkgs.bpftrace.overrideAttrs (old: {
      version = "master";
      CPATH = /tmp/linuxHeaders;
      src = super.fetchFromGitHub {
        owner = "iovisor";
        repo = "bpftrace";
        rev = "master";
        sha256 = "1z2s9m3miba663zm112adja85c8zv73lh45lbq3jqjn56pyqwbxg";
      };

    });
  });
  #linuxHeaders = (super.callPackage <nixpkgs/pkgs/os-specific/linux/kernel-headers> {}).makeLinuxHeaders {
  #  version = "5.9.11";
  #  src = self.fetchurl {
  #    url = "mirror://kernel/linux/kernel/v5.x/linux-5.9.11.tar.xz";
  #    sha256 = "0q6jlnigyjjnnxw6l724zv8acgs95s3pafabz4l9jrhhlijhmcjy";
  #  };
  #  patches = [ <nixpkgs/pkgs/os-specific/linux/kernel-headers/no-relocs.patch> ];
  #};

  galene = super.buildGoModule rec {
    pname = "galene";
    version = "0.1";

    src = super.fetchFromGitHub {
      owner = "jech";
      repo = "galene";
      rev = "v${version}";
      sha256 = "1s13hbzxdi059za7jhhcjy0daz04vh7sirmgnspid0xd4wh94mxf";
    };

    vendorSha256 = "0wi32aba0m2gc10kczs3v1lzwfm92xbc0j1ykq0ahvz4623r1dqc";

    outputs = [ "out" "static" ];

    postInstall = ''
      mkdir $static
      cp -r ./static $static
    '';

    meta = with super.stdenv.lib; {
      description = "Videoconferencing server that is easy to deploy, written in Go";
      homepage = "https://github.com/jech/galene";
      license = licenses.mit;
      platforms = platforms.linux;
      maintainers = with maintainers; [ rgrunbla ];
    };
  };
}
