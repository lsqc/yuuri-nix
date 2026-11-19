inputs:
let
  hosts = import ./hosts.nix;
  makeHosts =
    type:
    builtins.mapAttrs (
      host: hostConfig: {
        targetHost = hostConfig.ip;
        targetUser = hostConfig.targetUser or "root";
        targetPort = hostConfig.targetPort or 22;
      }
    );
in
makeHosts "lxc" hosts.lxc // makeHosts "vm" hosts.vm
