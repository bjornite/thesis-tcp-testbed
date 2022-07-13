# Installing NixOS for reproducible tests using Raspberry Pi 4B

## How to get a basic NixOS install running on both raspberry Pis

First, build a NixOS image for the raspberry pi. Unless you have an aarch64-compatible machine readily available, this step takes some bootstrapping.
We can use one of the Raspberry Pis as an aarch64 builder, but first we need to get NixOS running on it.
Luckily, NixOS images for Raspberry Pi are availble online. Download the generic image linked here and follow instruction to write it to an SD card: https://nix.dev/tutorials/installing-nixos-on-a-raspberry-pi

Insert the SD card and boot up. Connect the RPi to a keyboard/mouse/monitor and configure it so you can get SSH access from your laptop.

Once one of the Raspberry Pis is running NixOS and you have SSH access, we can configure it to be a build server for NixOps. The benefits of building images ourselves is that we can pre-load the images with information about which WiFi network we want it to connect to and which SSH keys we want to give access to.

A guide on how to configure remote builders can be found here (also see the comments in sd-image.nix): https://nixos.wiki/wiki/Distributed_build

Add your SSH keys to sd-image.nix. Then build the new image with 

`
nixos-generate -f sd-aarch64-installer --system aarch64-linux -c sd-image.nix
`

Once the image is built, flash it to each of the SD cards and plug them in.
Find the IPs of each machine and use these to configure the default.nix file.

We can now use NixOps to configure all of the machines at once.
Run:

```
nixops create default.nix
nixops list
nixops deploy
nixops info
```

If you have more than one nixops deployment, select the right one by setting the environment variable
```
bjorn@bjorn-ThinkPad-E14:~$ nixops list
+--------------------------------------+------------+--------------+------------+------+
| UUID                                 | Name       | Description  | # Machines | Type |
+--------------------------------------+------------+--------------+------------+------+
| 8fa4965c-f207-11ec-bb76-f875a46b3e4a | TCPtestbed | TCP testbed  |          2 | none |
| 0168c4e3-25ed-11ec-a898-f875a46b3e4a | testbed    | WiFi testbed |          9 | none |
+--------------------------------------+------------+--------------+------------+------+
bjorn@bjorn-ThinkPad-E14:~$ export NIXOPS_DEPLOYMENT=8fa4965c-f207-11ec-bb76-f875a46b3e4a

```
Finally, build and deploy:

```
bjorn@bjorn-ThinkPad-E14:~$ nixops deploy
```

I once found that the build failed when using the default release for nixos. The solution was to try another release.
This command can be used to configure a specific nixos release before running nixops build:

`export NIX_PATH=nixpkgs=https://releases.nixos.org/nixos/21.11/nixos-21.11.336020.2128d0aa28e/nixexprs.tar.xz`