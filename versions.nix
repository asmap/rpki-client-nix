{version}: let
  versionHashes = {
    "9.4" = {
      portable = "98954f463a60c1aa1f9c0c0de83370558ba452c7";
      openbsd = "27f8f58679530181c9e2f546046b714ad6f85b8c";
    };
    "9.3" = {
      portable = "12c58dcd8f61d18567fda0689ba64cb4b8c70a2d";
      openbsd = "2e884707a601e39d2ff82695f33bd3374fdc4135";
    };
    "9.2" = {
      portable = "6d8627a9ef5606f4df11534e3b88fa52b3004bb1";
      openbsd = "f4a424b1e698a4719ec8368bc93c340c03b2170d";
    };
    "9.1" = {
      portable = "a8aadf11866008666e17c65da76132659942fe2c";
      openbsd = "a59ae351b4f900cf90b01e755118290047fcdb28";
    };
    "9.0" = {
      portable = "47fb45fd13e402a21b51c794a76511a526b5d556";
      openbsd = "f701384e64e6644eedcdfb68379f76218a457f8e";
    };
    "8.9" = {
      portable = "70efa83594d4589521814fa782e1e453caf97697";
      openbsd = "85613947df83972df4a3206565587caceeab95d0";
    };
    "8.8" = {
      portable = "6453604c2c565a67853ac09758c7d7332f98cb0c";
      openbsd = "70024ad08f9d60fa6627c0cdf8ba7618d5e83136";
    };
    "8.7" = {
      portable = "b55270c7f1b7a876a887edffb479ac413dd36c3d";
      openbsd = "437fc95d80253ed514dba0bd98cad3c0bbef3238";
    };
    "8.6" = {
      portable = "aa554ab91add82bb68de00d323e02c9d20621aee";
      openbsd = "b254ff19168e66d677a24035010c2c0b8d303d3c";
    };
    "8.5" = {
      portable = "07a27ac52359837077743dbc5171ab2893dcc44d";
      openbsd = "48822602e1e7a49c904f9f23dd6500815b8f0830";
    };
    "8.4" = {
      portable = "678f9acc0f6e8d96e65daeed891caf277cbc4633";
      openbsd = "294220d37174b573c4dd0fe49b1531038d4d69d6";
    };
  };
  versionSet =
    if builtins.hasAttr version versionHashes
    then builtins.getAttr version versionHashes
    else throw "${version} is not valid RPKI version (minimum version: 8.4)";
in  "--override-input rpki-client-src github:rpki-client/rpki-client-portable/${versionSet.portable} --override-input rpki-openbsd-src github:rpki-client/rpki-client-openbsd/${versionSet.openbsd}"
