user: { pkgs, ... }:

{
  users.users.${user} = {
    description = "Peter Esselius";
    home = "/Users/${user}";
  };
}
