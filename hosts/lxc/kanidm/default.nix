{
  ...
}:
{
  imports = [ ./kanidm.nix ];

  networking.firewall.allowedTCPPorts = [
    8443
  ];
}
