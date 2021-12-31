{ pkgs, ... }:

{
  users.users.peteresselius = {
    description = "Peter Esselius";
    home = "/home/peteresselius";
    createHome = true;
    shell = pkgs.fish;
    isNormalUser = true;
    extraGroups = [ "docker" ];
  };
}
