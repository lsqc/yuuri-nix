{ inputs, hosts, ... }:

let
  handle-logo = path: ''
    handle ${path} {
      root * ${../../../assets}
      rewrite * /yuuri.svg
      file_server
    }
  '';
in
{
  services.caddy = {
    enable = true;
    virtualHosts = {
      "git.nya.vodka" = {
        extraConfig = ''
          handle {
            reverse_proxy http://[${hosts.lxc.forgejo.ip}]:${toString inputs.self.nixosConfigurations.forgejo.config.services.forgejo.settings.server.HTTP_PORT}
          }

          ${handle-logo "/assets/img/logo.svg"}
        '';
      };
      "id.nya.vodka" = {
        extraConfig = ''
          handle {
            reverse_proxy https://${toString inputs.self.nixosConfigurations.kanidm.config.services.kanidm.server.settings.bindaddress} {
              header_up X-Real-IP {remote_host}
              header_up X-Forwarded-For {remote_host}
              header_up X-Forwarded-Proto {scheme}
              transport http {
                tls_insecure_skip_verify
              }
            }
          }

          ${handle-logo "/pkg/img/logo.svg"}
          ${handle-logo "/pkg/img/logo-square.svg"}
          ${handle-logo "/pkg/img/favicon.svg"}
        '';
      };
    };
  };
}
