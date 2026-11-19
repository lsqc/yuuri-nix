{
  config,
  ...
}:
{
  imports = [
    ./prometheus.nix
    ./grafana.nix
  ];

  networking = {
    firewall.allowedTCPPorts = [
      config.services.grafana.settings.server.http_port
      22
    ];
  };
}
