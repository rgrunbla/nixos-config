{ config, pkgs, lib, options, ... }:

{
  # install basic packages
  services.printing.drivers = with pkgs; [
    cups-toshiba-estudio
  ];

   environment.systemPackages = with pkgs;
   [
     openconnect
   ];
}
