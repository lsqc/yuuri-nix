let
  prefixes = import ./common/prefixes.nix;
in
{
  other = {
    resolver = {
      ip = "${prefixes.services.literal}::10";
    };

    dn42 = {
      ip = "${prefixes.services.literal}::d42";
    };

    create = {
      ip = "${prefixes.services.literal}::42";
    };
  };

  lxc = {
    caddy = {
      ip = "${prefixes.services.literal}::6d";
    };

    forgejo = {
      ip = "${prefixes.services.literal}::f30";
    };

    kanidm = {
      ip = "${prefixes.services.literal}::41d";
    };

    velocity = {
      ip = "${prefixes.services.literal}::40";
    };

    prometheus = {
      ip = "${prefixes.services.literal}::37";
    };

    minecraft = {
      ip = "${prefixes.services.literal}::41";
    };
  };

  vm = { };
}
