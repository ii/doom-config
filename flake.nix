{
  description = "ii-doom-emacs shell";

  #### OPTION A
  #### Plainly use https://github.com/nix-community/nix-doom-emacs/blob/master/docs/reference.md#flake
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-doom-emacs.url = "github:nix-community/nix-doom-emacs";
  };
  outputs = { self, nixpkgs, nix-doom-emacs, ... }:
  let
    # system = builtins.currentSystem;
    system = "x86_64-linux";
    pkgs = import nixpkgs { inherit system; };
    doom-emacs = nix-doom-emacs.packages.${system}.default.override {
      doomPrivateDir = ./.;
      emacsPackage = pkgs.emacsPgtkNativeComp;
    };
  in
  {
    devShells.${system}.default = pkgs.mkShell {
      buildInputs = [ doom-emacs ];
    };
  };

  #### OPTION B
  #### Wrap nix-doom-emacs in each-system
  #### This will likely get it to work on Darwin and Linux
  #### https://github.com/numtide/flake-utils/blob/main/examples/each-system/flake.nix

  # inputs.flake-utils.url = "github:numtide/flake-utils";
  # outputs = { self, nixpkgs, flake-utils }:
  #   flake-utils.lib.eachDefaultSystem (system:
  #     let pkgs = nixpkgs.legacyPackages.${system}; in
  #     {
  #       # Unsure how to get our nix-doom-emacs flake into here
  #       packages = rec {
  #         hello = pkgs.hello;
  #         default = hello;
  #       };
  #       # apps = rec {
  #       #   hello = flake-utils.lib.mkApp { drv = self.packages.${system}.hello; };
  #       #   default = hello;
  #       # };
  #     }
  #   );

  #### OPTION C
  #### Simple Flake with overlays
  #### https://github.com/numtide/flake-utils/blob/main/examples/simple-flake/flake.nix

  # inputs.flake-utils.url = "github:numtide/flake-utils";
  # outputs = { self, nixpkgs, flake-utils }:
  #   flake-utils.lib.simpleFlake {
  #     inherit self nixpkgs;
  #     name = "iidoom";
  #     # preOverlays = [
  #     #   (import (builtins.fetchTarball {
  #     #     # url = "https://github.com/nix-community/nix-doom-emacs/archive/master.tar.gz";
  #     #     # sha256 = "8e0b9c0901999a86763e884b2cbd288f1aba6ef53d4d404f6717222d96ebd3ed";
  #     #     url = "https://github.com/nix-community/nix-doom-emacs/archive/588ccf37fa9eb9d2ec787b91c989dcd6892983e9.tar.gz";
  #     #     # sha256 = "9071dae89261d94bfba012da6ee7747f7fe7ce97b33bd3db095c552d6087a366";
  #     #     sha256 = "16f571gd1jja3nqffzqnf0b4w3n907n1k01sl3sd8dl7c37p601p";
  #     #   }))
  #     # ];
  #     overlay = ./overlay.nix;
  #     # https://github.com/numtide/flake-utils/blob/main/simpleFlake.nix#LL18C1-L19C1
  #     # use this to load other flakes overlays to supplement nixpkgs
  #     shell = ./shell.nix;
  #   };

  ##### NON WORKING SCRATCH
  # inputs = {
  #   nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  #   nix-doom-emacs.url = "github:nix-community/nix-doom-emacs";
  #   fake-utils.url = "github:numtide/flake-utils";
  # };
  # ## simplest-flake
  # outputs = { self, nixpkgs, flake-utils }:
  #   let
  #     # ndeRepo = prev.fetchFromGitHub {
  #     #       owner = "nix-community";
  #     #       repo = "nix-doom-emacs";
  #     #       rev = "5fbbb0dbaeda257427659f9168daa39c2f5e9b75";
  #     #       sha256 = "sha256-jj12GlDN/hYdwDqeOqwX97lOlvNCmCWaQjRB3+4+w7M=";
  #     #     };
  #     # nix-doom-emacs = final.callPackage  { import ndeRepo };
  #     ndeOverlay = prev: final: {
  #       ii-doom-emacs = prev.nix-doom-emacs.overrideAttrs (oldAttrs: {
  #          doomPrivateDir = ./.;
  #          emacsPackage = prev.emacsPgtkNativeComp;
  #       });
  #     };

  #     pkgsForSystem = system: import nixpkgs {
  #       overlays = [
  #         ndeOverlay
  #       ];
  #       inherit system;
  #     };
  # flake-utils.lib.simpleFlake {
  #   inherit self nixpkgs;
  #   name = "iimacs-flake";
  #   overlay = ./overlay.nix;
  #   preOverlays = [
  #     (import (builtins.fetchTarball {
        #   url = https://github.com/nix-community/emacs-overlay/archive/master.tar.gz;
        # }))
  # ]
  #   ./overlay.nix;
  #   shell = ./shell.nix;
  # };

  # outputs = { self, nixpkgs, flake-utils, nix-doom-emacs }:
  #   flake-utils.lib.eachDefaultSystem (system:
  #     let
  #       pkgs = import nixpkgs { inherit system; };
  #     in
  #     rec {

  #       doom-emacs = nix-doom-emacs.packages.${system}.default.override {
  #         doomPrivateDir = ./.;
  #         emacsPackage = pkgs.emacsPgtkNativeComp;
  #       };
  #       # packages.hello = pkgs.stdenv.mkDerivation {
  #       #   name = "hello";
  #       #   src = self;
  #       #   buildInputs = [ pkgs.gcc ];
  #       #   buildPhase = "gcc -o hello ./hello.c";
  #       #   installPhase = "mkdir -p $out/bin; install -t $out/bin hello";
  #       # };

  #       defaultPackage = doom-emacs;
  #       # devShells.${system}.default = pkgs.mkShell {
  #       #   buildInputs = [ doom-emacs ];
  #       # };

  #     }
  #   );

}
