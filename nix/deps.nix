{
  lib,
  beamPackages,
  overrides ? (x: y: {}),
}: let
  buildRebar3 = lib.makeOverridable beamPackages.buildRebar3;
  buildMix = lib.makeOverridable beamPackages.buildMix;
  buildErlangMk = lib.makeOverridable beamPackages.buildErlangMk;

  self = packages // (overrides self packages);

  packages = with beamPackages;
  with self; {
    autumn = buildMix rec {
      name = "autumn";
      version = "0.3.2";

      src = fetchHex {
        pkg = "autumn";
        version = "${version}";
        sha256 = "5c8c4a30f3159e7c63c7a3f97d274ec9693402aa30eede855870db7f390deb67";
      };

      beamDeps = [nimble_options rustler rustler_precompiled];
    };

    castore = buildMix rec {
      name = "castore";
      version = "1.0.12";

      src = fetchHex {
        pkg = "castore";
        version = "${version}";
        sha256 = "3dca286b2186055ba0c9449b4e95b97bf1b57b47c1f2644555879e659960c224";
      };

      beamDeps = [];
    };

    earmark_parser = buildMix rec {
      name = "earmark_parser";
      version = "1.4.44";

      src = fetchHex {
        pkg = "earmark_parser";
        version = "${version}";
        sha256 = "4778ac752b4701a5599215f7030989c989ffdc4f6df457c5f36938cc2d2a2750";
      };

      beamDeps = [];
    };

    ex_doc = buildMix rec {
      name = "ex_doc";
      version = "0.37.3";

      src = fetchHex {
        pkg = "ex_doc";
        version = "${version}";
        sha256 = "e6aebca7156e7c29b5da4daa17f6361205b2ae5f26e5c7d8ca0d3f7e18972233";
      };

      beamDeps = [earmark_parser makeup_elixir makeup_erlang];
    };

    jason = buildMix rec {
      name = "jason";
      version = "1.4.4";

      src = fetchHex {
        pkg = "jason";
        version = "${version}";
        sha256 = "c5eb0cab91f094599f94d55bc63409236a8ec69a21a67814529e8d5f6cc90b3b";
      };

      beamDeps = [];
    };

    makeup = buildMix rec {
      name = "makeup";
      version = "1.2.1";

      src = fetchHex {
        pkg = "makeup";
        version = "${version}";
        sha256 = "d36484867b0bae0fea568d10131197a4c2e47056a6fbe84922bf6ba71c8d17ce";
      };

      beamDeps = [nimble_parsec];
    };

    makeup_elixir = buildMix rec {
      name = "makeup_elixir";
      version = "1.0.1";

      src = fetchHex {
        pkg = "makeup_elixir";
        version = "${version}";
        sha256 = "7284900d412a3e5cfd97fdaed4f5ed389b8f2b4cb49efc0eb3bd10e2febf9507";
      };

      beamDeps = [makeup nimble_parsec];
    };

    makeup_erlang = buildMix rec {
      name = "makeup_erlang";
      version = "1.0.2";

      src = fetchHex {
        pkg = "makeup_erlang";
        version = "${version}";
        sha256 = "af33ff7ef368d5893e4a267933e7744e46ce3cf1f61e2dccf53a111ed3aa3727";
      };

      beamDeps = [makeup];
    };

    nimble_options = buildMix rec {
      name = "nimble_options";
      version = "1.1.1";

      src = fetchHex {
        pkg = "nimble_options";
        version = "${version}";
        sha256 = "821b2470ca9442c4b6984882fe9bb0389371b8ddec4d45a9504f00a66f650b44";
      };

      beamDeps = [];
    };

    nimble_parsec = buildMix rec {
      name = "nimble_parsec";
      version = "1.4.2";

      src = fetchHex {
        pkg = "nimble_parsec";
        version = "${version}";
        sha256 = "4b21398942dda052b403bbe1da991ccd03a053668d147d53fb8c4e0efe09c973";
      };

      beamDeps = [];
    };

    rustler = buildMix rec {
      name = "rustler";
      version = "0.36.1";

      src = fetchHex {
        pkg = "rustler";
        version = "${version}";
        sha256 = "f3fba4ad272970e0d1bc62972fc4a99809651e54a125c5242de9bad4574b2d02";
      };

      beamDeps = [jason toml];
    };

    rustler_precompiled = buildMix rec {
      name = "rustler_precompiled";
      version = "0.8.2";

      src = fetchHex {
        pkg = "rustler_precompiled";
        version = "${version}";
        sha256 = "63d1bd5f8e23096d1ff851839923162096364bac8656a4a3c00d1fff8e83ee0a";
      };

      beamDeps = [castore rustler];
    };

    toml = buildMix rec {
      name = "toml";
      version = "0.7.0";

      src = fetchHex {
        pkg = "toml";
        version = "${version}";
        sha256 = "0690246a2478c1defd100b0c9b89b4ea280a22be9a7b313a8a058a2408a2fa70";
      };

      beamDeps = [];
    };
  };
in
  self
