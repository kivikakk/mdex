{
  pkgs,
  lib,
  beamPackages,
  autumn,
  elixir,
  rust,
}: let
  mixNixDeps = import ./deps.nix {
    inherit lib beamPackages;
    overrides = final: prev: {
      inherit autumn;
    };
  };

  comrak_nif = pkgs.rustPlatform.buildRustPackage {
    pname = "comrak_nif";
    version = "0.1.0";
    src = ../native/comrak_nif;
    cargoLock = {
      lockFile = ../native/comrak_nif/Cargo.lock;
      outputHashes = {
        #"autumnus-0.3.2" = "sha256-ekJIDK6keVxYcixrVrkGZhEwb2P9Cl5mqdSeq9ZeVCA=";
      };
    };
  };
in
  beamPackages.buildMix {
    name = "mdex";
    # TODO: parse from mix.exs
    version = "0.6.2-dev";
    src = ../.;

    beamDeps = builtins.attrValues mixNixDeps;

    buildInputs = [elixir];

    appConfigExs = pkgs.writeText "config.exs" ''
      import Config

      config :mdex, MDEx.Native,
        crate: :comrak_nif,
        skip_compilation?: true
    '';

    preConfigure = ''
      mkdir -p priv/native
      # HACK: ensure the target is .so, even if it was a .dylib. (Nix on Darwin
      # workaround.)
      cp ${comrak_nif}/lib/libcomrak_nif.* priv/native/libcomrak_nif.so

      mkdir -p config
      cp $appConfigExs config/config.exs
    '';

    env.RUSTLER_PRECOMPILED_FORCE_BUILD_ALL = "true";
    env.RUSTLER_PRECOMPILED_GLOBAL_CACHE_PATH = "fake";
  }
