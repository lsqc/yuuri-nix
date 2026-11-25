{ pkgs, inputs, ... }:

{
  imports = [
    ./velocity.nix
  ];

  nixpkgs.overlays = [
    inputs.nix-minecraft.overlay
  ];

  environment.systemPackages = [ pkgs.tmux ];
}
