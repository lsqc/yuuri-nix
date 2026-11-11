{
  config,
  modulesPath,
  ...
}:
{
  imports = [
    (modulesPath + "/virtualisation/proxmox-lxc.nix")
    ./forgejo.nix
  ];

  networking.firewall.allowedTCPPorts = [
    22
    config.services.forgejo.settings.server.HTTP_PORT
  ];

  systemd.network = {

    enable = true;

    networks."10-eth" = {
      address = [ "2a01:4f8:13a:f801::f30" ];
    };
  };
}
