#!/bin/bash -e

rm "${BINARIES_DIR}"/extra.vfat || true

dd if=/dev/zero of="${BINARIES_DIR}/extra.vfat" bs=30M count=1 || exit 1
$HOST_DIR/sbin/mkfs.vfat -F32 "${BINARIES_DIR}/extra.vfat" || exit 1

$HOST_DIR/bin/mmd -i "${BINARIES_DIR}/extra.vfat" ::/boot || exit 1

$HOST_DIR/bin/mcopy -p -m -i "${BINARIES_DIR}/extra.vfat" board/shredos/fsoverlay/etc/shredos/version.txt ::/boot/version.txt || exit 1
$HOST_DIR/bin/mcopy -p -m -i "${BINARIES_DIR}/extra.vfat" board/shredos/README.txt ::/README.txt || exit 1
$HOST_DIR/bin/mcopy -p -m -i "${BINARIES_DIR}/extra.vfat" board/shredos/autorun.inf ::/autorun.inf || exit 1
$HOST_DIR/bin/mcopy -p -m -i "${BINARIES_DIR}/extra.vfat" board/shredos/shredos.ico ::/shredos.ico || exit 1
