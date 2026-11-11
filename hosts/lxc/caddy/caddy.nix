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
    };
  };
}
