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

  networking.firewall.allowedTCPPorts = config.services.openssh.ports ++ [
    config.services.forgejo.settings.server.HTTP_PORT
    config.services.forgejo.settings.server.SSH_PORT
  ];
}
