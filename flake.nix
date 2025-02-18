{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = {
    self,
    nixpkgs,
  }: let
    pkgs = nixpkgs.legacyPackages.x86_64-linux;
    esp-rs = pkgs.callPackage ./esp-rs/default.nix {};
  in {
    devShells.x86_64-linux.default = pkgs.mkShell  {
        name = "lora-rs";

        buildInputs = [
          esp-rs
          pkgs.rustup
          pkgs.espflash
          pkgs.rust-analyzer
          pkgs.pkg-config
          pkgs.stdenv.cc
          pkgs.bacon
          pkgs.systemdMinimal
        ];

        shellHook = ''
        export PS1="(esp-rs)$PS1"
        # this is important - it tells rustup where to find the esp toolchain,
        # without needing to copy it into your local ~/.rustup/ folder.
        #export RUSTUP_TOOLCHAIN=${esp-rs}
        '';
    };
  };
}
