{ overlays ? []
}@args:

let
  inherit (nixpkgs) pkgs lib stdenv;

  python-overlay = self: super: {
    my-python = self.python3;
  };

  env-overlay = self: super: {
    my-env = super.buildEnv {
      name = "my-env";
      paths = with self; [
        my-python
      ];
    };
  };

  nixpkgs = import <nixpkgs> (args // {
    overlays = overlays ++ [
      python-overlay
      env-overlay
    ];
  });

  lib-path = lib.makeLibraryPath [
    stdenv.cc.cc
  ];

in

pkgs.mkShell {
  buildInputs = with pkgs; [
    my-env
    poetry
  ];

  shellHook = ''
    export "LD_LIBRARY_PATH=${lib-path}"
  '';
}
