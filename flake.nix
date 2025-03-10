{
  description = "MDEx";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable"; # need unstable for 1.86.0
    flake-utils.url = "github:numtide/flake-utils";
    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    autumn = {
      url = "github:kivikakk/autumn/nix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
      inputs.rust-overlay.follows = "rust-overlay";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
      rust-overlay,
      autumn,
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        overlays = [ (import rust-overlay) ];
        pkgs = import nixpkgs { inherit system overlays; };
        erlang = pkgs.beam_minimal.interpreters.erlang_27;
        beamPackages = pkgs.beam_minimal.packagesWith erlang;
        elixir = beamPackages.elixir_1_18;
        rust-ver = pkgs.rust-bin.stable.latest;
      in
      {
        formatter = pkgs.nixfmt-rfc-style;

        packages = rec {
          default = mdex;

          mdex = pkgs.callPackage ./nix/package.nix {
            inherit beamPackages elixir;
            rust = rust-ver.minimal;
            autumn = autumn.packages.${system}.default;
          };
        };

        devShells.default = import ./nix/shell.nix {
          inherit
            pkgs
            beamPackages
            erlang
            elixir
            ;
          rust = rust-ver.default;
        };
      }
    );
}
