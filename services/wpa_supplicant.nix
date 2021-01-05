{ config, ... }:

{
  # PSKs
  imports =
    [
      ../nixos-secrets/common/wireless.nix
    ];

  # Wi-Fi
  networking.wireless.enable = true;
  networking.wireless.driver = "nl80211";
  networking.wireless.extraConfig = ''
    ctrl_interface=/run/wpa_supplicant
    ctrl_interface_group=wheel
  '';

  networking.wireless.userControlled.enable = true;

}
