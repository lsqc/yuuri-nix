{
  config,
  ...
}:
{
  imports = [ ./kanidm.nix ];

  networking.firewall.allowedTCPPorts = [
    config.services.kanidm.settings.server.HTTP_PORT
  ];
}
