{
  hostConfig,
  hosts,
  pkgs,
  ...
}:

{
  services.minecraft-servers = {

    enable = true;
    eula = true;
    user = "minecraft";

    openFirewall = true;
    servers.velocity = {
      enable = true;

      jvmOpts = "-Xmx1G -Xms512M";
      package = pkgs.velocity;

      symlinks = {
        "plugins/viaversion.jar" = builtins.fetchurl {
          url = "https://cdn.modrinth.com/data/P1OZGk5p/versions/ZH8459B6/ViaVersion-5.11.0.jar?mr_download_reason=standalone&mr_game_version=26.2&mr_loader=velocity";
          name = "velocity.jar";
          sha256 = "0w1glnjyhy279631pg8bfshfpgm2x6lvfazfbs7j6x76wg47dnw9";
        };

        "plugins/viabackwards.jar" = builtins.fetchurl {
          url = "https://cdn.modrinth.com/data/NpvuJQoq/versions/hYhg2QBT/ViaBackwards-5.11.0.jar?mr_download_reason=standalone&mr_game_version=26.2&mr_loader=velocity";
          name = "viabackwards.jar";
          sha256 = "1p7c7vrqycldy13x0pw2lyfil82yxy3p9zhp978s1jc4sxcml221";
        };

        # "plugins/luckperms.jar" = builtins.fetchurl {
        #   url = "https://cdn.modrinth.com/data/Vebnzrzj/versions/tamnmXad/LuckPerms-Velocity-5.5.71.jar?mr_download_reason=standalone&mr_game_version=26.2&mr_loader=velocity";
        #   name = "luckperms.jar";
        #   sha256 = "12m19xan4aj23352cdfky75g2inrbx295p06syj8gz999vpr5b53";
        # };

        # "plugins/luckperms/config.yml" = config.age.secrets.luckperms-config.path;
      };

      files."velocity.toml".value = {
        config-version = "2.8";
        bind = "[${hostConfig.ip}]:25565";

        motd = "velocity proxy";
        show-max-players = 1000;

        ping-passthrough = "all";

        online-mode = true;
        force-key-authentication = true;

        player-info-forwarding-mode = "legacy";

        servers = {
          create = "[${hosts.lxc.minecraft-create.ip}]:25565";
          try = [ "create" ];
        };

        forced-hosts = { };
      };
    };
  };

  # age.secrets.luckperms-config = {
  #   file = ../../../../secrets/luckperms-config.age;
  #   mode = "400";
  #   owner = "${config.services.minecraft-servers.user}";
  # };
}
