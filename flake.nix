{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/release-22.05";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = inputs:
    let
      overlay = final: prev: { };
      perSystem = system:
        let
          pkgs = import inputs.nixpkgs { inherit system; overlays = [ overlay ]; };

          my-python = pkgs.python3.withPackages (p: with p; [
            pip
            setuptools
            virtualenv
            wheel
          ]);

          lib-path = with pkgs; lib.makeLibraryPath [
            stdenv.cc.cc
          ];

          dev-env = pkgs.buildEnv {
            name = "dev-env";
            paths = with pkgs; [
              my-python
              my-python.pkgs.pip
              poetry
              gnumake
            ];

            # nativeBuildInputs = [
            #   pkgs.makeWrapper
            # ];

            # postBuild = ''
            #   wrapProgram $out/bin/python \
            #     --set LD_LIBRARY_PATH ${lib-path}
            #   wrapProgram $out/bin/poetry \
            #     --set LD_LIBRARY_PATH ${lib-path}
            # '';
          };
        in
        {
          devShell = pkgs.mkShell {
            buildInputs = with pkgs; [
              dev-env
            ];

            LD_LIBRARY_PATH = lib-path;
          };
        };
    in
    { inherit overlay; } // inputs.flake-utils.lib.eachDefaultSystem perSystem;
}
