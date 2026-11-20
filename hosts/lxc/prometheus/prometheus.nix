{ lib, hosts, ... }:

{
  services.prometheus = {
    enable = true;
    scrapeConfigs = [
      {
        job_name = "node";
        static_configs = [
          {
            targets =
              (lib.mapAttrsToList (_: host: "[${host.ip}]:9092") hosts.lxc)
              ++ (lib.mapAttrsToList (_: host: "[${host.ip}]:9092") hosts.vm)
              ++ (lib.mapAttrsToList (_: host: "[${host.ip}]:9092") hosts.other);
          }
        ];
      }
      {
        job_name = "frr";
        metrics_path = "/metrics";
        static_configs = [
          {
            targets = [
              "[${hosts.other.dn42.ip}]:9342"
            ];
          }
        ];
      }
      {
        job_name = "caddy";
        metrics_path = "/metrics";
        static_configs = [
          {
            targets = [
              "[${hosts.lxc.caddy.ip}]:6666"
            ];
          }
        ];
      }
    ];
  };
}
