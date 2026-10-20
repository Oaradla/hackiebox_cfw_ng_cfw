# HackieboxNG SD bootloader with trial start

A small change to the SD bootloader of
[HackieboxNG](https://github.com/toniebox-reverse-engineering/hackiebox_cfw_ng)
by SciLor and contributors, for the
[Hackiebox1_CFW](https://github.com/Oaradla/Hackiebox1_CFW) custom firmware
of the first-generation Toniebox (CC3200). This repository holds only the
change, as a patch; `build.sh` fetches HackieboxNG at a fixed commit, applies
the patch and builds.

## What the patch adds

- **Boot state file.** `ngCfg.json` → `"general": {"stateFile": "/revvox/boot/ngstate.bin"}`
  names a 32-byte file on the card (magic `NGS1`, CRC-32) with the active
  slot and a pending one.
- **Trial start and rollback.** A slot marked pending is started once. If the
  started image does not confirm itself, the load fails or the watchdog
  resets the box, the bootloader starts the active slot again and records
  the result. A firmware update therefore cannot leave the box without a
  working image.
- The file is rewritten in place through a direct sector write; FatFs stays
  read-only.
- Before the jump the bootloader leaves a small handover record at
  `0x20003FE0` for SD images that are not the original firmware.
- The SD card stays powered when an SD image is started.

Without a `stateFile` entry the bootloader behaves exactly as HackieboxNG.

## Build

```sh
./build.sh          # clones HackieboxNG into work/, applies patches/, builds
```

The result is in `work/exe/sd-bootloader-ng/` (`sd/revvox/boot/ngbootloader.bin`
and the preloader `flash/sys/mcuimg.bin`) and as a zip next to it. The
custom firmware's release script takes it with
`BOOTLOADER=$PWD/work tools/release.sh VERSION`. The toolchain and the TI
CC3200 SDK come with HackieboxNG.

## Legal

Toniebox, Tonie and tonies are trademarks of tonies GmbH (formerly Boxine
GmbH). This project is not affiliated with, endorsed or supported by tonies
GmbH; the names only say which devices the software works with.

Changing the firmware of a box, opening it or connecting to its debug port
is at your own risk: a box can become unusable, and it can affect claims
against the manufacturer. The software comes without any warranty.

HackieboxNG is the work of SciLor and contributors; its upstream repository
publishes no licence file. The patch in `patches/` changes files of
HackieboxNG and is offered to the upstream project.
