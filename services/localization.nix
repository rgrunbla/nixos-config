{ config, ... }:

{
  # english locales, german keyboard layout
  i18n = {
    defaultLocale = "fr_FR.UTF-8";
  };
  console.font = "Lat2-Terminus16";
  console.keyMap = "fr-bepo";

  time.timeZone = "Europe/Paris";
}
