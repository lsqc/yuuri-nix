{
  type,
  hostName,
  hosts,
  ...
}:
{

  imports = [ ./users.nix ];

  system.stateVersion = "26.11";

  services = {

    openssh = {
      enable = true;
      settings = {
        UseDns = true;
        PasswordAuthentication = false;
        PermitRootLogin = "prohibit-password";
      };
    };

    resolved.enable = true;
  };

  systemd.network = {

    enable = true;

    networks."10-eth" = {
      matchConfig.Name = "eth0";
      linkConfig.RequiredForOnline = "routable";

      address = [ hosts.${type}.${hostName}.ip ];
      dns = [
        hosts.other.resolver.ip
        "2620:fe::fe"
      ];

      networkConfig = {
        DHCP = "no";
        LinkLocalAddressing = "ipv6";
        IPv6AcceptRA = true;
      };
    };
  };
}
