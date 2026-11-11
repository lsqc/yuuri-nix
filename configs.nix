inputs:
let
  hosts = import ./hosts.nix;
  system = "x86_64-linux";

  commonModules = rec {
    lxc = [
      ./common/default.nix
      ./common/lxc.nix
    ];
    vm = [ ];
  };

  makeHosts =
    with inputs.nixpkgs.lib;
    type:
    builtins.mapAttrs (
      host: hostConfig:

      nixosSystem {
        inherit system;
        modules = commonModules.${type} ++ [
          ./hosts/${type}/${host}
        ];
        specialArgs = {
          inherit
            inputs
            hosts
            host
            type
            hostConfig
            ;
          hostName = host;
        };
      }
    );
in
makeHosts "lxc" hosts.lxc // makeHosts "vm" hosts.vm
