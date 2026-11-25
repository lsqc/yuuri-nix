{ pkgs, inputs, ... }:

{
  imports = [
    ./paper.nix
  ];

  nixpkgs.overlays = [
    inputs.nix-minecraft.overlay
  ];

  environment.systemPackages = [ pkgs.tmux ];

  networking.firewall = {
    allowedTCPPorts = [
      22
      25565
    ];

    allowedUDPPorts = [ 25565 ];
  };
}
