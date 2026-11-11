let
  prefixes = import ./common/prefixes.nix;
in
{
  other = {
    resolver = {
      ip = "${prefixes.services.literal}::10";
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
  };

  vm = { };
}
