{ config, pkgs, ... }:

{
  # Redshift Configuration
  location.latitude = 45.75;
  location.longitude = 4.85;
  services.redshift = {
    enable = true;
    package = pkgs.redshift-wlr;
  };
}
