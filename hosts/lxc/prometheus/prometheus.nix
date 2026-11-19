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
              ++ (lib.mapAttrsToList (_: host: "[${host.ip}]:9092") hosts.vm);
          }
        ];
      }
    ];
  };
}
