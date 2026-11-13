{
  description = "A very basic flake";

  inputs = {

    nixpkgs.url = "https://channels.nixos.org/nixpkgs-unstable/nixexprs.tar.zst";

    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    kirikae.url = "git+https://git.sr.ht/~xqtc/kirikae";

    nix-minecraft.url = "github:Infinidoge/nix-minecraft";
    nix-minecraft-folia.url = "github:viceebun/nix-minecraft-folia";
  };

  outputs =
    inputs@{
      ...
    }:
    {
      nixosConfigurations = import ./configs.nix inputs;
      kirikae = {
        hosts = import ./kirikae.nix inputs;
      };
    };
}
