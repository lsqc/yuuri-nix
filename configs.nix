inputs:
let
  hosts = import ./hosts.nix;
  system = "x86_64-linux";

  opts = {
    kanidm = rec {
      domain = "id.nya.vodka";
      url = "https://${domain}";
    };
  };

  commonModules = rec {
    all = [
      ./common/default.nix
      inputs.agenix.nixosModules.default
    ];
    lxc = all ++ [
      ./common/lxc.nix
    ];
    vm = all ++ [ ];
  };

  hostModules = {
    velocity = [
      inputs.nix-minecraft.nixosModules.minecraft-servers
    ];
    minecraft = [
      inputs.nix-minecraft.nixosModules.minecraft-servers
    ];
  };

  makeHosts =
    with inputs.nixpkgs.lib;
    type:
    builtins.mapAttrs (
      host: hostConfig:

      nixosSystem {
        inherit system;
        modules =
          commonModules.${type}
          ++ (hostModules.${host} or [ ])
          ++ [
            ./hosts/${type}/${host}
          ];
        specialArgs = {
          inherit
            inputs
            hosts
            host
            type
            hostConfig
            opts
            ;
          hostName = host;
        };
      }
    );
in
makeHosts "lxc" hosts.lxc // makeHosts "vm" hosts.vm
