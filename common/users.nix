{ ... }:

let
  keys = import ../keys.nix;
in
{
  users.users.root = {
    openssh.authorizedKeys.keys = keys.userKeys.regular.lsqc ++ keys.userKeys.sk.lsqc;
  };
}
