user: { pkgs, ... }:

{
  users.users.${user} = {
    home = "/home/${user}";
    createHome = true;
    shell = pkgs.fish;
    isNormalUser = true;
    extraGroups = [ "docker" ];
  };
  networking.firewall.enable = false;
  # services.clickhouse.enable = true;
  programs.sysdig.enable = true;
}
