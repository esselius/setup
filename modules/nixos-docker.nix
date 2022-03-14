{
  virtualisation.docker = {
    enable = true;
    listenOptions = [
      "/var/docker.sock"
      "127.0.0.1:2375"
    ];
    extraOptions = "--bip 172.17.42.1/24";
  };
}
