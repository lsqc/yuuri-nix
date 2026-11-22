{ inputs, ... }:

{
  imports = [
    ./paper.nix
  ];

  nixpkgs.overlays = [
    inputs.nix-minecraft.overlay
  ];

  networking.firewall = {
    allowedTCPPorts = [
      22
      25565
    ];

    allowedUDPPorts = [ 25565 ];
  };
}
