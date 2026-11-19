{
  pkgs,
  opts,
  hostConfig,
  config,
  ...
}:

{
  services.grafana = {
    enable = true;

    settings = {
      security = {
        secret_key = "$__file{${config.age.secrets.grafana-secret-key.path}}";
        disable_initial_admin_creation = true;
      };
      server = {
        root_url = "https://grafana.yuuri.nya.vodka";
        domain = "grafana.yuuri.nya.vodka";
        http_port = 3000;
        http_addr = "${hostConfig.ip}";
      };

      analytics.reporting_enabled = false;

      auth.disable_login_form = true;

      "auth.generic_oauth" = {
        enabled = true;
        name = "Kanidm";
        allow_sign_up = true;

        client_id = "grafana";
        client_secret = "$__file{${config.age.secrets.grafana-oidc-client-secret.path}}";

        scopes = "openid profile email groups";
        use_pkce = true;
        use_refresh_token = true;

        auth_url = "${opts.kanidm.url}/ui/oauth2";
        token_url = "${opts.kanidm.url}/oauth2/token";
        api_url = "${opts.kanidm.url}/oauth2/openid/grafana/userinfo";

        login_attribute_path = "preferred_username";
        groups_attribute_path = "groups";

        role_attribute_path = "contains(groups[*], 'grafana-admins@${opts.kanidm.domain}') && 'Admin' || contains(groups[*], 'grafana-editors') && 'Editor' || 'Viewer'";
        allow_assign_grafana_admin = true;
      };
    };

    provision = {

      enable = true;
      datasources.settings = {
        apiVersion = 1;

        datasources = [
          {
            name = "prometheus";
            type = "prometheus";
            url = "http://[${hostConfig.ip}]:9090";
            isDefault = true;
          }
        ];
      };
      dashboards.settings = {
        apiVersion = 1;

        providers = [
          {
            name = "default";
            options.path = "/etc/grafana-dashboards";
          }
        ];
      };
    };
  };

  environment.etc = {
    "grafana-dashboards/node-exporter-full.json" = {
      source = pkgs.fetchurl {
        name = "node-exporter-full.json";
        url = "https://grafana.com/api/dashboards/1860/revisions/46/download";
        hash = "sha256-5Y3cXcU11MkB+U2pZIvD49Wue2946Y4YW86LKJlhzqM=";
      };
    };
  };

  age.secrets = {
    grafana-secret-key = {
      file = ../../../secrets/grafana-secret-key.age;
      owner = "grafana";
      group = "grafana";
      mode = "0400";
    };
    grafana-oidc-client-secret = {
      file = ../../../secrets/grafana-oidc-client-secret.age;
      owner = "grafana";
      group = "grafana";
      mode = "0400";
    };
  };
}
