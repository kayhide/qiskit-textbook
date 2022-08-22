{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/release-22.05";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = inputs:
    let
      overlay = final: prev: {
        my-python = final.python3;
      };
      perSystem = system:
        let
          pkgs = import inputs.nixpkgs { inherit system; overlays = [ overlay ]; };

          lib-path = with pkgs; lib.makeLibraryPath [
            stdenv.cc.cc
          ];
        in
        {
          devShell = pkgs.mkShell {
            buildInputs = with pkgs; [
              my-python
              poetry
              gnumake
            ];
            LD_LIBRARY_PATH = lib-path;

          };
        };
    in
    { inherit overlay; } // inputs.flake-utils.lib.eachDefaultSystem perSystem;
}
