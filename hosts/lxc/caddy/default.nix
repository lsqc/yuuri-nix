{
  ...
}:
{
  imports = [
    ./caddy.nix
  ];

  networking = {
    firewall.allowedTCPPorts = [
      22
      80
      443
      6666
    ];
  };
}
