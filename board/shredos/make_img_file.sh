#!/bin/bash -e

if grep -Eq "^BR2_ARCH_IS_64=y$" "${BR2_CONFIG}"; then
	MKIMAGE_ARCH=x86_64
	MKIMAGE_EFI=bootx64.efi
else
	MKIMAGE_ARCH=i386
	MKIMAGE_EFI=bootia32.efi
fi

version=$(cat board/shredos/fsoverlay/etc/shredos/version.txt)

cp "board/shredos/grub.cfg"                            "${BINARIES_DIR}/grub.cfg"         || exit 1
cp "output/target/lib/grub/i386-pc/boot.img"           "${BINARIES_DIR}/boot.img"         || exit 1
cp "${BINARIES_DIR}/efi-part/EFI/BOOT/${MKIMAGE_EFI}"  "${BINARIES_DIR}/${MKIMAGE_EFI}"   || exit 1

cp "board/shredos/autorun.inf"             "${BINARIES_DIR}/autorun.inf"                  || exit 1
cp "board/shredos/README.txt"              "${BINARIES_DIR}/README.txt"                   || exit 1
cp "board/shredos/shredos.ico"             "${BINARIES_DIR}/shredos.ico"                  || exit 1

# version.txt is used to help identify the (boot) USB disk
cp "board/shredos/fsoverlay/etc/shredos/version.txt" "${BINARIES_DIR}/version.txt"        || exit 1

rm -rf "${BUILD_DIR}/genimage.tmp"                                                        || exit 1
genimage --rootpath="${TARGET_DIR}" \
    --inputpath="${BINARIES_DIR}" \
    --outputpath="${BINARIES_DIR}" \
    --config="board/shredos/genimage_${MKIMAGE_ARCH}.cfg" \
    --tmppath="${BUILD_DIR}/genimage.tmp"                                                 || exit 1

SUFFIXIMG="${version}_$(date +%Y%m%d)"
FINAL_IMAGE_PATH="${BINARIES_DIR}/shredos-${SUFFIXIMG}.img"
mv "${BINARIES_DIR}/shredos.img" "${FINAL_IMAGE_PATH}"                                    || exit 1

echo
echo "==============================================="
echo "  USB image '${FINAL_IMAGE_PATH}'"
echo "  (for '${MKIMAGE_ARCH}' architecture)"
echo "  CREATED SUCCESSFULLY!"
echo "==============================================="
echo

exit 0
