{
  description = "myproject";

  nixConfig = {
    bash-prompt-prefix = "(myproject) ";
    bash-prompt = ''\[\033]0;\u@\h:\w\007\]\[\033[01;32m\]\u@\h\[\033[01;34m\] \w \$\[\033[00m\]'';
    bash-prompt-suffix = " ";
  };

  inputs = {
    nixpkgs = {
      url = "github:nixos/nixpkgs";

      # This needs to follow the `nixpkgs` from nativelink so that the local LRE
      # toolchains are in sync with the remote toolchains.
      follows = "nativelink/nixpkgs";
    };
    flake-utils.url = "github:numtide/flake-utils";
    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };
    pre-commit-hooks = {
      url = "github:cachix/pre-commit-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nativelink = {
      # Keep this commit in sync with the LRE commit in `MODULE.bazel`.
      url = "github:TraceMachina/nativelink/v0.4.0";

      # This repository provides the autogenerated LRE toolchains which are
      # dependent on the nixpkgs version in the nativelink repository. To keep
      # the local LRE toolchains aligned with remote LRE, we need to use the
      # nixpkgs used by nativelink as the the "global" nixpkgs. We do this by
      # setting `nixpkgs.follows = "nativelink/nixpkgs"` above.

      inputs.flake-utils.follows = "flake-utils";
      inputs.flake-parts.follows = "flake-parts";
      inputs.pre-commit-hooks.follows = "pre-commit-hooks";
    };
    rules_ll = {
      # Keep this commit in sync with the rules_ll commit in `MODULE.bazel`.
      url = "github:eomii/rules_ll/5ac0546db310da08d44f14271066e0b159611c25";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
      inputs.flake-parts.follows = "flake-parts";
      inputs.pre-commit-hooks.follows = "pre-commit-hooks";
      inputs.nativelink.follows = "nativelink";
    };
    nix2container = {
      follows = "nativelink/nix2container";
    };
    rules_mojo = {
      # Keep this commit in sync with the rules_mojo commit in `MODULE.bazel`
      url = "github:TraceMachina/rules_mojo/<TODO: Specify rules_mojo commit>";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
      inputs.flake-parts.follows = "flake-parts";
      inputs.pre-commit-hooks.follows = "pre-commit-hooks";
      inputs.nativelink.follows = "nativelink";
      inputs.rules_ll.follows = "rules_ll";
    };
  };

  outputs =
    { self
    , nixpkgs
    , flake-utils
    , pre-commit-hooks
    , flake-parts
    , nativelink
    , rules_ll
    , rules_mojo
    , nix2container
    , ...
    } @ inputs:
    flake-parts.lib.mkFlake { inherit inputs; }
      {
        systems = [
          "x86_64-linux"
        ];
        imports = [
          inputs.nativelink.flakeModule
          inputs.pre-commit-hooks.flakeModule
          inputs.rules_ll.flakeModule
          inputs.rules_mojo.flakeModule
        ];
        perSystem =
          { config
          , pkgs
          , system
          , lib
          , ...
          }:
          {
            _module.args.pkgs = import self.inputs.nixpkgs {
              inherit system;
              # CUDA support
              # config.allowUnfree = true;
              # config.cudaSupport = true;
            };
            local-remote-execution.settings = {
              inherit (nativelink.packages.${system}.lre-cc.meta) Env;
            };
            pre-commit.settings = {
              hooks = import ./pre-commit-hooks.nix { inherit pkgs; };
            };
            rules_ll.settings.llEnv =
              let
                openssl = (pkgs.openssl.override { static = true; });
              in
              rules_ll.lib.defaultLlEnv {
                inherit pkgs;
                LL_CFLAGS = "-I${openssl.dev}/include";
                LL_LDFLAGS = "-L${openssl.out}/lib";
              };
            rules_mojo.settings.mojoEnv = rules_mojo.lib.defaultMojoEnv {
              inherit pkgs;
              mojo = inputs.rules_mojo.packages.${system}.mojo;
            };
            packages = {
              lre-mojo = rules_mojo.packages.${system}.lre-mojo;
              lre-cc = nativelink.packages.${system}.lre-cc;
              nativelink-worker-lre-mojo = rules_mojo.packages.${system}.lre-mojo;
            };
            devShells.default = pkgs.mkShell {
              nativeBuildInputs = [
                rules_mojo.packages.${system}.mojo
                rules_mojo.packages.${system}.lre-mojo-cluster
                rules_mojo.packages.${system}.lre-kill-the-mojo
                rules_mojo.packages.${system}.bazel
                rules_mojo.packages.${system}.lre-bazel
                pkgs.kubectl
                pkgs.zlib
                pkgs.python312
                pkgs.tektoncd-cli
                pkgs.kind
              ];


              shellHook = ''
                # Generate the .pre-commit-config.yaml symlink when entering the
                # development shell.
                ${config.pre-commit.installationScript}

                # Generate .bazelrc.ll which containes action-env
                # configuration when rules_ll is run from a nix environment.
                ${config.rules_ll.installationScript}

                # Generate .bazelrc.mojo which contains Bazel configuration
                # when rules_mojo is run from a nix environment.
                ${config.rules_mojo.installationScript}

                # Generate .bazelrc.lre which configures the LRE toolchains.
                ${config.local-remote-execution.installationScript}

                # Ensure that the bazel command points to our custom wrapper.
                [[ $(type -t bazel) == "alias" ]] && unalias bazel
              '';
            };
          };
      };
}