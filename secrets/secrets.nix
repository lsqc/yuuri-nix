let
  keys = import ../keys.nix;
in
{
  "forgejo-oidc-client-secret.age" = {
    publicKeys = keys.userKeys.regular.lsqc ++ keys.hostKeys.forgejo ++ keys.hostKeys.kanidm;
  };

  "kanidm-idm-admin-password.age" = {
    publicKeys = keys.userKeys.regular.lsqc ++ keys.hostKeys.kanidm;
  };

  "kanidm-admin-password.age" = {
    publicKeys = keys.userKeys.regular.lsqc ++ keys.hostKeys.kanidm;
  };
}
