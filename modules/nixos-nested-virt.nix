{ pkgs, ... }:

{
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModprobeConfig = "options kvm_intel nested=1";
  boot.kernelParams = [ "intel_iommu=on" ];
}


