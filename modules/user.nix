{
  users.users.root = { password = "vagrant"; };

  users.groups.vagrant = {
    name = "vagrant";
    members = [ "vagrant" ];
  };

  users.users.vagrant = {
    isNormalUser = true;
    description = "Vagrant User";
    name = "vagrant";
    group = "vagrant";
    extraGroups = [ "users" "wheel" ];
    password = "vagrant";
    home = "/home/vagrant";
    createHome = true;
    useDefaultShell = true;
    openssh.authorizedKeys.keys = [
      ("ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEA6NF8iallvQVp22" +
        "WDkTkyrtvp9eWW6A8YVr+kz4TjGYe7gHzIw+niNltGEFHzD8+v" +
        "1I2YJ6oXevct1YeS0o9HZyN1Q9qgCgzUFtdOKLv6IedplqoPkc" +
        "mF0aYet2PkEDo3MlTBckFXPITAMzF8dJSIFo9D8HfdOV0IAdx4" +
        "O7PtixWKn5y2hMNG0zQPyUecp4pzC6kivAIhyfHilFR61RGL+G" +
        "PXQ2MWZWFYbAGjyiYJnAmCP3NOTd0jMZEnDkbUvxhMmBYSdETk" +
        "1rRgm+R4LOzFUGaHqHDLKLX+FIPKcF96hrucXzcWyLbIbEgE98" +
        "OHlnVYCzRdK8jlqm8tehUc9c9WhQ== vagrant insecure public key")
    ];
  };

  security.sudo.extraConfig =
    ''
      Defaults:root,%wheel env_keep+=LOCALE_ARCHIVE
      Defaults:root,%wheel env_keep+=NIX_PATH
      Defaults:root,%wheel env_keep+=TERMINFO_DIRS
      Defaults env_keep+=SSH_AUTH_SOCK
      Defaults lecture = never
      root   ALL=(ALL) SETENV: ALL
      %wheel ALL=(ALL) NOPASSWD: ALL, SETENV: ALL
    '';
}
