inputs: final: prev: {
  dns-heaven = prev.callPackage ../pkgs/dns-heaven.nix { src = inputs.dns-heaven; };
  nix = prev.nixUnstable;
}
