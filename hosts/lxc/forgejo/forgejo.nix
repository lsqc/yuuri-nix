{ ... }:

{
  services.forgejo = {
    enable = true;
    settings = {
      DISABLE_REGISTRATION = true;
      server = rec {
        HTTP_ADDR = "2a01:4f8:13a:f801::f30";
        DOMAIN = "git.nya.vodka";
        ROOT_URL = "https://${DOMAIN}";
        HTTP_PORT = 5000;
      };
    };
  };
}
