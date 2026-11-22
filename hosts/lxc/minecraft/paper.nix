{
  pkgs,
  ...
}:

let
  operators = {
    lsqc = "c32bb0f4-eda0-477c-b16c-87390a7979b8";
  };
in
{
  services.minecraft-servers = {

    enable = true;
    eula = true;
    user = "minecraft";

    openFirewall = true;
    servers.paper = {
      enable = true;

      jvmOpts = "-Xmx16G -Xms1G -Djava.net.preferIPv6Addresses=true -Djava.net.preferIPv4Stack=false";
      package = pkgs.paperServers."paper-26_3";

      inherit operators;
      whitelist = operators // { };

      serverProperties = {
        white-list = true;
        online-mode = false;
      };

      symlinks = {

        "spigot.yml" = pkgs.writeText "spigot.yml" ''
          settings:
            bungeecord: true
        '';

        # "plugins/luckperms/config.yml" = config.age.secrets.luckperms-config.path;
      };
    };
  };

  # age.secrets.luckperms-config = {
  #   file = ../../../../secrets/luckperms-config.age;
  #   mode = "400";
  #   owner = "${config.services.minecraft-servers.user}";
  # };
}
