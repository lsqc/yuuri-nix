{
  hostConfig,
  pkgs,
  config,
  ...
}:

let
  domain = "id.nya.vodka";
in
{
  security.acme = {
    acceptTerms = true;
    certs."${domain}" = {
      group = "kanidm";
      webroot = "/var/lib/acme/acme-challenge";
    };
  };

  services.kanidm = {
    package = pkgs.kanidmWithSecretProvisioning_1_12;

    server = {
      enable = true;
      settings = {

        inherit domain;
        origin = "https://${domain}";
        bindaddress = "[${hostConfig.ip}]:8443";

        tls_chain = "/var/lib/acme/${domain}/fullchain.pem";
        tls_key = "/var/lib/acme/${domain}/key.pem";

        log_level = "info";
      };
    };

    provision = {
      instanceUrl = "https://[${hostConfig.ip}]:8443";
      acceptInvalidCerts = true;
      enable = true;
      autoRemove = true;

      adminPasswordFile = config.age.secrets.kanidm-admin-password.path;
      idmAdminPasswordFile = config.age.secrets.kanidm-idm-admin-password.path;

      persons = {
        "lsqc" = {
          displayName = "lsqc";
          mailAddresses = [ "lsqc@nya.vodka" ];
        };
      };

      groups = {
        "forgejo-admins" = {
          members = [ "lsqc" ];
        };

        "forgejo-users" = {
          members = [ ];
        };

        "grafana-users" = {
          members = [ ];
        };

        "grafana-admins" = {
          members = [ "lsqc" ];
        };
      };

      systems.oauth2 = {
        "forgejo" = {
          displayName = "Forgejo";
          imageFile = ../../../assets/icons/forgejo.svg;

          originUrl = "https://git.nya.vodka/user/oauth2/id.nya.vodka/callback";
          originLanding = "https://git.nya.vodka/user/oauth2/id.nya.vodka";

          basicSecretFile = config.age.secrets.forgejo-oidc-client-secret.path;

          preferShortUsername = true;

          scopeMaps = {
            "forgejo-users" = [
              "openid"
              "email"
              "profile"
            ];
            "forgejo-admins" = [
              "openid"
              "email"
              "profile"
            ];
          };
        };
      };
    };
  };

  age.secrets =
    let
      owner = "kanidm";
      group = owner;
    in
    {
      forgejo-oidc-client-secret = {
        inherit owner group;
        file = ../../../secrets/forgejo-oidc-client-secret.age;
        mode = "0400";
      };

      kanidm-idm-admin-password = {
        inherit owner group;
        file = ../../../secrets/kanidm-idm-admin-password.age;
        mode = "0400";
      };

      kanidm-admin-password = {
        inherit owner group;
        file = ../../../secrets/kanidm-admin-password.age;
        mode = "0400";
      };
    };
}
