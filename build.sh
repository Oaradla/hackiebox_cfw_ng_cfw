#!/bin/bash
# Builds the HackieboxNG SD bootloader with trial start and rollback: HackieboxNG
# at the commit below, with the patches of this repository applied.
#
# usage: ./build.sh            -> work/exe/sd-bootloader-ng/ (and its zip)
#   UPSTREAM=<path or URL>       another source of HackieboxNG (default: GitHub)
# Then the custom firmware's release script takes it: BOOTLOADER=$PWD/work tools/release.sh VERSION
set -e
cd "$(dirname "$0")"
UPSTREAM=${UPSTREAM:-https://github.com/toniebox-reverse-engineering/hackiebox_cfw_ng.git}
BASE=aad9035ad2af88560215af40fc6b5b340caff017

if [ ! -d work/.git ]; then
    git clone -q "$UPSTREAM" work
fi
cd work
if ! git rev-parse -q --verify cfw-trial-boot >/dev/null; then
    git checkout -q -b cfw-trial-boot "$BASE"
    git -c user.name=build -c user.email=build@localhost am -q ../patches/*.patch
else
    git checkout -q cfw-trial-boot
fi
common/buildAndShip.bootloader.sh
echo "SD bootloader: $PWD/exe/sd-bootloader-ng"
