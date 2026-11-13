{ inputs, ... }:

{
  imports = [
    ./velocity.nix
  ];

  nixpkgs.overlays = [
    inputs.nix-minecraft.overlay
  ];
}
