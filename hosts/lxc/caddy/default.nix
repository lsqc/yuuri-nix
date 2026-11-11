{
  modulesPath,
  ...
}:
{
  imports = [
    (modulesPath + "/virtualisation/proxmox-lxc.nix")
    ./caddy.nix
  ];

  networking = {
    firewall.allowedTCPPorts = [
      22
      80
      443
    ];
  };
}
