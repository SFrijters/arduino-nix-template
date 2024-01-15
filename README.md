# Arduino sketches with Nix

This is a template for building reproducible Arduino sketches with the help of [Nix](https://nixos.org/download.html), with [flakes enabled](https://github.com/mschwaig/howto-install-nix-with-flake-support).

## Quickstart

```console
$ nix develop
$ make -C blink compile
$ make -C blink upload
```

## nix develop

`nix develop` provides a reproducible development environment via a [Nix flake](flake.nix): `arduino-cli` and other system packages are pinned via Nix, but `arduino-cli` still downloads its own libraries. These are in turn pinned via the the [build profile](https://arduino.github.io/arduino-cli/0.34/sketch-project-file/) in the [sketch.yaml](blink/sketch.yaml) file.

For NixOS: make sure the user is in the `dialout` group to access the serial port.

```nix
users.users.<user>.extraGroups = [ "dialout" ];
```

## arduino-cli

Current version pinned via `nixpkgs`: 0.34.2.

Use `make` for some predefined options to compile and upload the sketch.

You may need to modify the options at the top of the [Makefile](blink/Makefile) to make the upload work.

You may need to modify the options in [sketch.yaml](blink/sketch.yaml) to make it work on a different device (fqbn/platform). In its original state it's set up for the Wemos D1 Mini.

Hints to compile / upload from command line without the`Makefile`: https://arduino.github.io/arduino-cli/0.34/getting-started/ .

## Cache directory

When you enter the development environment, various `ARDUINO_DIRECTORIES_...` variables are set. These are respected by `arduino-cli`.

* If you have set `_ARDUINO_PROJECT_DIR` yourself, it will use this directly as the base directory of the cache for this project.
* Else, if you have set `_ARDUINO_ROOT_DIR` youself, it will use `${_ARDUINO_ROOT_DIR}/${name}` where `name` is the project name as defined in the flake.
* Else, if you have set `XDG_CACHE_HOME` youself, it will use `${XDG_CACHE_HOME}/arduino/${name}` where `name` is the project name as defined in the flake.
* Else, it will use `${HOME}/.arduino/${name}` where `name` is the project name as defined in the flake.
