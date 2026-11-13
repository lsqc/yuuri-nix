rec {
  base = rec {
    literal = "2a01:4f8:13a:f8";
    cidr = "${literal}00::/56";
  };

  services = rec {
    literal = "${base.literal}01";
    cidr = "${literal}::/64";
  };

  nat64 = rec {
    literal = "${base.literal}01:64";
    cidr = "${literal}::/96";
  };
}
