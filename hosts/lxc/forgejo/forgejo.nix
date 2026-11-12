{
  hostConfig,
  ...
}:

{

  systemd.services.forgejo = {
    after = [ "network-online.target" ];
    wants = [ "network-online.target" ];
  };

  services = {

    forgejo = {
      enable = true;
      settings = {
        service = {
          DISABLE_REGISTRATION = true;
          ALLOW_ONLY_EXTERNAL_REGISTRATION = true;
          ENABLE_INTERNAL_SIGNIN = false;
          SHOW_REGISTRATION_BUTTON = false;
        };
        server = rec {

          HTTP_ADDR = hostConfig.ip;
          DOMAIN = "git.nya.vodka";
          ROOT_URL = "https://${DOMAIN}";
          HTTP_PORT = 5000;

          START_SSH_SERVER = true;
          SSH_DOMAIN = "git.nya.vodka";
          SSH_LISTEN_HOST = hostConfig.ip;
          SSH_PORT = 2222;
        };
      };
    };
  };
}
