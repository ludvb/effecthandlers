{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system overlays; };
        overlay = (final: prev: { });
        overlays = [ overlay ];
      in {
        inherit overlay overlays;
        devShell = pkgs.mkShell rec {
          name = "venv";
          venvDir = "./.venv";
          buildInputs = let
            systemPackages = with pkgs; [ ];
            pythonPackages = with pkgs.python310Packages; [
              attrs
              ipdb
              ipython
              python
              venvShellHook
            ];
          in pythonPackages ++ systemPackages;

          postVenvCreation = postShellHook + ''
            pip install -e .
          '';

          postShellHook = "";
        };
      });
}
