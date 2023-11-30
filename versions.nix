{version}: let
  versionHashes = {
    "8.6" = {
      portable = "aa554ab91add82bb68de00d323e02c9d20621aee";
      openbsd = "082ed00f2b1f8b1b578b2bc9eae84a5fc1923d68";
    };
    "8.5" = {
      portable = "07a27ac52359837077743dbc5171ab2893dcc44d";
      openbsd = "48822602e1e7a49c904f9f23dd6500815b8f0830";
    };
    "8.4" = {
      portable = "678f9acc0f6e8d96e65daeed891caf277cbc4633";
      openbsd = "fcba5c234b2137895ff8cf6f006e752626f2dd72";
    };
  };
  versionSet =
    if builtins.hasAttr version versionHashes
    then builtins.getAttr version versionHashes
    else throw "${version} is not valid RPKI version";
in  "--override-input rpki-client-src github:rpki-client/rpki-client-portable/${versionSet.portable} --override-input rpki-openbsd-src github:rpki-client/rpki-client-openbsd/${versionSet.openbsd}"
