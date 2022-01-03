user: { pkgs, ... }:

{
  users.users.${user} = {
    home = "/home/${user}";
    createHome = true;
    shell = pkgs.fish;
    isNormalUser = true;
    extraGroups = [ "docker" ];
  };
}
