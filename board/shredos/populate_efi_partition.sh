#!/bin/bash
#
# Our hybrid all-in-one ISO has an accessible EFI partition, which we
# can (ab)use to store our information also, so we move the usual data
# onto it before creating the images. This should not cause any issues
# for CD/DVD-ROM burned ISO images, as the EFI partition will be in RAM,
# but allow any USB burned ISO images to have that accessible data location.
#
# Keep in mind that the EFI partition needs to be loaded into RAM when
# the ISO image is burned to CD/DVD-ROM, so it should not be huge, as this
# could cause issues on 32-bit UEFI (not that it is very common, but still).
#

mkdir -p "${BINARIES_DIR}/efi-part/boot/"                                                               || exit 1

cp "board/shredos/autorun.inf"             "${BINARIES_DIR}/efi-part/autorun.inf"                       || exit 1
cp "board/shredos/README.txt"              "${BINARIES_DIR}/efi-part/README.txt"                        || exit 1
cp "board/shredos/shredos.ico"             "${BINARIES_DIR}/efi-part/shredos.ico"                       || exit 1
cp "board/shredos/fsoverlay/etc/shredos/version.txt" "${BINARIES_DIR}/efi-part/boot/version.txt"        || exit 1

exit 0
