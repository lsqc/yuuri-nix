{
  hostConfig,
  lib,
  config,
  ...
}:
{

  services.prometheus = {
    enable = true;
    port = 9090;
    exporters = {
      node = {
        enable = true;
        listenAddress = "[${hostConfig.ip}]";
        port = 9092;
        openFirewall = true;
        enabledCollectors = [
          "sysctl"

          "filesystem"
          "systemd"
          "processes"
          "pressure"
          "stat"

          "sockstat"
          "netstat"
          "netclass"
          "arp"
          "network_route"
          "netdev"
          "ethtool"
          "tcpstat"
          "ipvs"
          "cpu"
          "os"
          "swap"
          "meminfo"
        ];
      };
    };
  };
}
