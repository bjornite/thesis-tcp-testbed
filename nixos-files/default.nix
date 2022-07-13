{
  network = {
    storage.legacy = {};
    description = "TCP testbed";
  };

  defaults = {
    imports = [ ./common.nix ];
  };
  
  server =
    { config, pkgs, ... }:
    {
      networking.hostName = "server";
      nixpkgs.system = "aarch64-linux";
      deployment.targetHost = "192.168.1.176";
      imports = [./hardware-configuration.nix
                 ./chrony_server.nix
                 ./tailscale.nix];
      boot.kernelModules = [ "tcp_bbr"
                             "tcp_cubic"
                             "tcp_highspeed"
                             "tcp_hybla"
                             "tcp_illinois"
                             "tcp_nv"
                             "tcp_scalable"
                             "tcp_westwood"
                             "tcp_yeah"
                             "tcp_dctcp"];
    };

  client =
    { config, pkgs, ... }:
    {
      networking.hostName = "client";
      nixpkgs.system = "aarch64-linux";
      deployment.targetHost = "192.168.1.249";
      imports = [./hardware-configuration.nix
                 ./chrony_client.nix
                 ./tailscale.nix];
      boot.kernelModules = [ "tcp_bbr"
                             "tcp_cubic"
                             "tcp_highspeed"
                             "tcp_hybla"
                             "tcp_illinois"
                             "tcp_nv"
                             "tcp_scalable"
                             "tcp_westwood"
                             "tcp_yeah"
                             "tcp_dctcp"];
      boot.kernel.sysctl = {
        "net.ipv4.tcp_congestion_control" = "scalable";
    };
  };
}