{ config, ... }:

{
  nix.useSandbox = true;
  nix.sandboxPaths = [
    "/var/cache/ccache"
  ];
}
