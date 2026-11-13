{
  type,
  hostName,
  hosts,
  ...
}:

let
  prefixes = import ./prefixes.nix;
in
{

  imports = [ ./users.nix ];

  system.stateVersion = "26.11";

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

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

  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 22 ];
  };

  systemd.network = {

    enable = true;

    networks."10-eth" = {
      matchConfig.Name = "eth0";
      linkConfig.RequiredForOnline = "routable";

      address = [ hosts.${type}.${hostName}.ip ];

      routes = [
        {
          Destination = "${prefixes.nat64.cidr}";
          Gateway = "${prefixes.services.literal}::10";
          Metric = 100;
        }
      ];

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
