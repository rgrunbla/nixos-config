self: super:
{
  linuxPackages = super.linuxPackages.extend (selfLinuxPkgs: superLinuxPkgs: {
    bpftrace = superLinuxPkgs.bpftrace.overrideAttrs (old: {
      version = "master";
      CPATH = /tmp/linuxHeaders;
      src = super.fetchFromGitHub {
        owner  = "iovisor";
        repo   = "bpftrace";
        rev    = "master";
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
}