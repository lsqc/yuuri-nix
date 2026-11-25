{ pkgs, inputs, ... }:

{
  imports = [
    ./velocity.nix
  ];

  nixpkgs.overlays = [
    inputs.nix-minecraft.overlay
  ];

  networking.firewall.allowedTCPPorts = [
    22
    44412
  ];

  environment.systemPackages = [ pkgs.tmux ];
}
