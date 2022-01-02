user: { pkgs, ... }:

{
  environment.shells = [ pkgs.fish ];

  users.users.${user} = {
    description = "Peter Esselius";
    home = "/Users/${user}";
    createHome = true;
    shell = pkgs.fish;
  };
}
