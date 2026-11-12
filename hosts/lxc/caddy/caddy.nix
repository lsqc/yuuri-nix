{ inputs, hosts, ... }:

{
  services.caddy = {
    enable = true;
    virtualHosts = {
      "git.nya.vodka" = {
        extraConfig = ''
          reverse_proxy http://[${hosts.lxc.forgejo.ip}]:${toString inputs.self.nixosConfigurations.forgejo.config.services.forgejo.settings.server.HTTP_PORT}
        '';
      };
      "id.nya.vodka" = {
        extraConfig = ''
          reverse_proxy https://${toString inputs.self.nixosConfigurations.kanidm.config.services.kanidm.server.settings.bindaddress} {
            header_up X-Real-IP {remote_host}
            header_up X-Forwarded-For {remote_host}
            header_up X-Forwarded-Proto {scheme}
            transport http {
              tls_insecure_skip_verify
            }
          }
        '';
      };
    };
  };
}
