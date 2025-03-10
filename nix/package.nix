{
  pkgs,
  lib,
  beamPackages,
  autumn,
  elixir,
  ...
}:
let
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
    };
  };

  mixExsVersion =
    let
      mixExs = builtins.readFile ../mix.exs;
      groups = builtins.match ".*@version \"([^\"]+)\".*" mixExs;
    in
    builtins.elemAt groups 0;
in
beamPackages.buildMix {
  name = "mdex";
  version = mixExsVersion;
  src = ../.;

  beamDeps = builtins.attrValues mixNixDeps;

  buildInputs = [ elixir ];

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
