{
  fileSystems."/".device = "/dev/disk/by-label/nixos";
  boot.initrd.availableKernelModules = [ "xhci_pci" "ehci_pci" "ahci" "usbhid" "usb_storage" "sd_mod" "virtio_balloon" "virtio_blk" "virtio_pci" "virtio_ring" ];
  boot.loader = {
    grub = {
      version = 2;
      device = "/dev/vda";
    };
    timeout = 0;
  };
  services.openssh.enable = true;
  networking.firewall.allowedTCPPorts = [ 22 ];
  users = {
    mutableUsers = false;
    users.root.openssh.authorizedKeys.keys = [ "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDbVgHBk+qDcDz92WsBjzMBZVwqS7nqMzFanTwYbLGXJfe8I1lxDkmIe2s9V19PoJjBOOI5P+p7rEpbDpTPHR5FW36lSCpH5dsCIRMjxZ7/Ybh08lARj2YVk1oYhmMi95rigYFAXmYG5COo/VNMQq6NsyaINAg3oTVjbZq2DL+Wpz5Jx9dToXA9IJihbK0LukQorTr1xTF2WRQ0l9HUnm9NEcKguK0yX7ESzBHNOn4LHdNEgKIEkGOpzyJl434n7AoI1uMxh/nNtL+41/7wzLGL65Vj8wbjIE+o5m51NA+aPAuR7F9fgb0jXkO4B1pTfbZWrdlyF3tYoYzhrErtABnp" ];
  };
}
