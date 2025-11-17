#!/bin/bash -e

version=$(cat board/shredos/fsoverlay/etc/shredos/version.txt)

SUFFIXISO="${version}_$(date +%Y%m%d)"
FINAL_ISO_PATH="${BINARIES_DIR}/shredos-${SUFFIXISO}.iso"

mv "${BINARIES_DIR}/rootfs.iso9660" "${FINAL_ISO_PATH}"

echo "ISO image '${FINAL_ISO_PATH}' created successfully!"
