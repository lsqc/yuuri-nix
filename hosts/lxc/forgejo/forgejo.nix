{
  config,
  hostConfig,
  ...
}:

{

  systemd.services.forgejo = {
    after = [ "network-online.target" ];
    wants = [ "network-online.target" ];
  };

  services = {
    openssh.ports = [ 2222 ];

    forgejo = {
      enable = true;
      settings = {
        service.DISABLE_REGISTRATION = true;
        server = rec {

          HTTP_ADDR = hostConfig.ip;
          DOMAIN = "git.nya.vodka";
          ROOT_URL = "https://${DOMAIN}";
          HTTP_PORT = 5000;

          START_SSH_SERVER = true;
          SSH_DOMAIN = "git.nya.vodka";
          SSH_LISTEN_HOST = hostConfig.ip;
          SSH_PORT = 22;
        };
      };
    };
  };
}
