# Arduino sketches with Nix

This is a template for building reproducible Arduino sketches with the help of [Nix](https://nixos.org/download.html), with [flakes enabled](https://nixos.wiki/wiki/Flakes#Enable_flakes).

## Quickstart

```console
$ nix develop
$ cd blink
$ make
```

## nix develop

`nix develop` provides a semi-reproducible development environment via a [Nix flake](flake.nix): `arduino-cli` and other system packages are pinned via Nix, but `arduino-cli` still downloads its own libraries. These are in turn pinned via the `sketch.yaml` file.

For NixOS: make sure the user is in the `dialout` group to access the serial port.

```nix
users.users.<user>.extraGroups = [ "dialout" ];
```

## arduino-cli

Current version pinned via `nixpkgs`: 0.29.0.

Use `make` for some predefined options to compile and upload the sketch.

You may need to modify the options at the top of the [Makefile](blink/Makefile) to make the upload work.

You may need to modify the options in [sketch.yaml](blink/sketch.yaml) to make it work on a different device (fqbn/platform). In its original state it's set up for the Wemos D1 Mini.

Hints to compile / upload from command line without the`Makefile`: https://create.arduino.cc/projecthub/B45i/getting-started-with-arduino-cli-7652a5 .
