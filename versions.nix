{version}: let
  versionHashes = {
    "9.3" = {
      portable = "12c58dcd8f61d18567fda0689ba64cb4b8c70a2d";
      openbsd = "dfa32b728c451dab0c97c854fbe23bc7b9be25ad";
    };
    "9.2" = {
      portable = "6d8627a9ef5606f4df11534e3b88fa52b3004bb1";
      openbsd = "7d2c70c4b4060e915c367d1e9366a8c098cc1bc4";
    };
    "9.1" = {
      portable = "a8aadf11866008666e17c65da76132659942fe2c";
      openbsd = "a59ae351b4f900cf90b01e755118290047fcdb28";
    };
    "9.0" = {
      portable = "47fb45fd13e402a21b51c794a76511a526b5d556";
      openbsd = "d64b7617dc536b6c76a0c87113c4586479c4a3d2";
    };
    "8.9" = {
      portable = "ee15321f92158f5b78ca7da3b33a7a7d26fcf91d";
      openbsd = "85613947df83972df4a3206565587caceeab95d0";
    };
    "8.8" = {
      portable = "6453604c2c565a67853ac09758c7d7332f98cb0c";
      openbsd = "70024ad08f9d60fa6627c0cdf8ba7618d5e83136";
    };
    "8.7" = {
      portable = "b55270c7f1b7a876a887edffb479ac413dd36c3d";
      openbsd = "979fa5f4d8fd7d2e02c6fddef0d6ff9a04944547";
    };
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
    else throw "${version} is not valid RPKI version (minimum version: 8.4)";
in  "--override-input rpki-client-src github:rpki-client/rpki-client-portable/${versionSet.portable} --override-input rpki-openbsd-src github:rpki-client/rpki-client-openbsd/${versionSet.openbsd}"
