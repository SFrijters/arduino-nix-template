{
  description = "Flake template for Arduino projects";

  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
    nixpkgs.url = "github:NixOS/nixpkgs";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachSystem [ "x86_64-linux" ] (system:
      let
        name = "blink";

        pkgs = import nixpkgs {
          inherit system;
        };

        # The variables starting with underscores are custom,
        # the ones starting with ARDUINO are used by arduino-cli.

        # Store everything that arduino-cli downloads in a directory
        # reserved for this project, and following the XDG specification,
        # if the variable is available.

        # The _ARDUINO_PYTHON3 variable is passed to arduino-cli via the Makefile.
        arduinoShellHookPaths = ''
          if [ -z ''${XDG_CACHE_HOME:-} ]; then
              export _ARDUINO_ROOT=$HOME/.arduino/${name}
          else
              export _ARDUINO_ROOT=$XDG_CACHE_HOME/arduino/${name}
          fi
          export _ARDUINO_PYTHON3=${pkgs.python3}
          export ARDUINO_DIRECTORIES_USER=$_ARDUINO_ROOT
          export ARDUINO_DIRECTORIES_DATA=$_ARDUINO_ROOT
          export ARDUINO_DIRECTORIES_DOWNLOADS=$_ARDUINO_ROOT/staging
        '';

        devShellArduinoCLI =
          pkgs.mkShell ({
            name = "${name}-dev";
            packages = with pkgs; [
              arduino-cli
              git
              gnumake
              python3
            ];
            shellHook = ''
              ${arduinoShellHookPaths}
              echo "==> Storing arduino-cli data in $_ARDUINO_ROOT"
            '';
          });

      in
        rec {
          devShells = {
            inherit
              devShellArduinoCLI
            ;
          };

          # Development shell spawned by `nix develop`
          devShells.default = devShellArduinoCLI;
        }
    );
}
