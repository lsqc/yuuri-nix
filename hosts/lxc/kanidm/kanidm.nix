{
  opts,
  inputs,
  hostConfig,
  pkgs,
  config,
  ...
}:

let
  domain = opts.kanidm.domain;
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

      groups = rec {
        "admins" = {
          members = [ "lsqc" ];
        };

        "forgejo-admins" = {
          members = admins.members;
        };

        "forgejo-users" = {
          members = [ ];
        };

        "grafana-users" = {
          members = [ ];
        };

        "grafana-admins" = {
          members = admins.members;
        };
      };

      systems.oauth2 = {
        "forgejo" = {
          displayName = "Forgejo";
          imageFile = ../../../assets/icons/forgejo.svg;
          preferShortUsername = true;

          originUrl = "${inputs.self.nixosConfigurations.forgejo.config.services.forgejo.settings.server.ROOT_URL}/user/oauth2/id.nya.vodka/callback";
          originLanding = "${inputs.self.nixosConfigurations.forgejo.config.services.forgejo.settings.server.ROOT_URL}/user/oauth2/id.nya.vodka";

          basicSecretFile = config.age.secrets.forgejo-oidc-client-secret.path;

          claimMaps.forgejo_groups = {
            joinType = "array";
            valuesByGroup."forgejo-admins" = [ "admin" ];
          };

          scopeMaps = {
            "forgejo-users" = [
              "openid"
              "email"
              "profile"
              "groups"
            ];
            "forgejo-admins" = [
              "openid"
              "email"
              "profile"
              "groups"
            ];
          };
        };
        "grafana" = {
          displayName = "Grafana";
          imageFile = ../../../assets/icons/grafana.svg;
          preferShortUsername = true;

          originUrl = "${inputs.self.nixosConfigurations.prometheus.config.services.grafana.settings.server.root_url}/login/generic_oauth";
          originLanding = "${inputs.self.nixosConfigurations.prometheus.config.services.grafana.settings.server.root_url
          }";

          basicSecretFile = config.age.secrets.grafana-oidc-client-secret.path;

          scopeMaps = {
            "grafana-users" = [
              "openid"
              "email"
              "profile"
              "groups"
            ];
            "grafana-admins" = [
              "openid"
              "email"
              "profile"
              "groups"
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
      grafana-oidc-client-secret = {
        inherit owner group;
        file = ../../../secrets/grafana-oidc-client-secret.age;
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
