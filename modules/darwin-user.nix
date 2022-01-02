{ pkgs, ... }:

{
  environment.shells = [ pkgs.fish ];

  users.users.peteresselius = {
    description = "Peter Esselius";
    home = "/Users/peteresselius";
    createHome = true;
    shell = pkgs.fish;
  };
}
