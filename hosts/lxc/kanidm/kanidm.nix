{
  hostConfig,
  pkgs,
  config,
  ...
}:

{
  services.kanidm = {
    package = pkgs.nixpkgs.kanidmWithSecretProvisioning_1_12;

    server = {
      enable = true;
      settings = {

        domain = "id.nya.vodka";
        origin = "https://id.nya.vodka";
        bindaddress = "[${hostConfig.ip}]:8443";

        log_level = "info";
      };
    };

    provision = {

      adminPasswordFile = config.age.secrets.kanidm-admin-password.path;
      idmAdminPasswordFile = config.age.secrets.kanidm-idm-admin-password.path;

      enable = true;
      autoRemove = true;
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
          imageFile = ../../../assets/kanidm-logos/forgejo-logo.svg;
          originUrl = "https://git.nya.vodka/user/oauth2/kanidm/callback";
          originLanding = "https://git.nya.vodka/user/oauth2/kanidm";
          preferShortUsername = true;

          scopeMaps = {
            "forgejo-users" = [
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
