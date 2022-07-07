{
  description = "Rust broker-v2 dev environment";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-22.05";
    flake-compat = {
      url = "github:edolstra/flake-compat";
      flake = false;
    };
    deploy-rs = {
      url = "github:serokell/deploy-rs";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.naersk.follows = "naersk";
      inputs.flake-compat.follows = "flake-compat";
      inputs.utils.follows = "flake-utils";
    };
    fenix = {
      url = "github:nix-community/fenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    flake-utils = {
      url = "github:numtide/flake-utils";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    naersk = {
      url = "github:nmattia/naersk";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    fenix,
    naersk,
    flake-utils,
    deploy-rs,
    ...
  }:
  # I'm specifying the system for now
  # because deploy-rs has an issue with
  # glibc
  # error: Package ‘glibc-2.34-210’ in
  # /nix/store/aq4mhn....-glibc/pkgs/development/libraries/glibc/default.nix:157
  # is not supported on ‘aarch64-darwin’, refusing to evaluate.
  # Correct version:
  #flake-utils.lib.eachDefaultSystem (
    flake-utils.lib.eachSystem ["x86_64-linux"] (
      system: let
        pkgs = import nixpkgs {
          inherit system;
          overlays = [
            fenix.overlay
            deploy-rs.overlay
          ];
        };
        nativeBuildInputs =
          [
            (fenix.packages."${system}".stable.withComponents [
              "cargo"
              "rust-src"
              "rust-docs"
              "rustc"
            ])
            pkgs.rust-analyzer
            pkgs.pkg-config
            pkgs.glib
            pkgs.glibc
            pkgs.openssl
          ]
          ++ pkgs.lib.optionals pkgs.stdenv.isDarwin [
            pkgs.darwin.apple_sdk.frameworks.Security
            pkgs.darwin.apple_sdk.frameworks.CoreFoundation
          ];
      in rec {
        checks = deploy-rs.lib."${system}".deployChecks {
          nodes = pkgs.lib.filterAttrs (name: cfg: cfg.profiles.system.path.system == system) self.deploy.nodes;
        };

        devShells.default = pkgs.mkShell {
          inherit nativeBuildInputs;
          RUST_SRC_PATH = "${fenix.packages.${system}.stable.rust-src}/bin/rust-lib/src";
          LD_LIBRARY_PATH = pkgs.lib.makeLibraryPath nativeBuildInputs;
          NIX_LDFLAGS = "${pkgs.lib.optionalString pkgs.stdenv.isDarwin "\
            -F${pkgs.darwin.apple_sdk.frameworks.Security}/Library/Frameworks -framework Security \
            -F${pkgs.darwin.apple_sdk.frameworks.CoreFoundation}/Library/Frameworks -framework CoreFoundation"}";
          buildInputs = with pkgs; [
            (fenix.packages."${system}".stable.withComponents ["clippy" "rustfmt"])
            pkgs.just
            deploy-rs.packages."${system}".deploy-rs
          ];
        };
        apps.deploy = {
          type = "app";
          program = "${deploy-rs.packages."${system}".deploy-rs}/bin/deploy";
        };
        packages.default =
          (naersk.lib.${system}.override {
            inherit (fenix.packages.${system}.minimal) cargo rustc;
          })
          .buildPackage {src = ./.;};
      }
    )
    // {
      nixosConfigurations = {
        "keys.walletconnect.com" = nixpkgs.lib.nixosSystem rec {
          system = "x86_64-linux";
          modules = [
            ({
              pkgs,
              config,
              ...
            }: {
              nix = {
                extraOptions = ''
                  experimental-features = nix-command flakes
                  keep-outputs = true
                  keep-derivations = true
                '';
                trustedUsers = ["root"];
              };
              environment.systemPackages = [self.packages."${system}".default];
              networking.hostName = "keys-walletconnect-com";
              systemd.services."keyserver" = {
                wantedBy = ["multi-user.target"];
                serviceConfig = {
                  Restart = "on-failure";
                  ExecStart = "${self.packages."${system}".default}/bin/keyserver";
                  DynamicUser = "yes";
                };
              };
            })
            ./hosts/keys.walletconnect.com
          ];
        };
      };

      deploy.nodes = {
        "keys.walletconnect.com" = {
          hostname = "159.65.123.131";
          sshUser = "root";
          fastConnection = true;
          profiles.system = {
            user = "root";
            path =
              deploy-rs.lib.x86_64-linux.activate.nixos
              self.nixosConfigurations."keys.walletconnect.com";
          };
        };
      };
    };
}
