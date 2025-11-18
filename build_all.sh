#!/bin/bash

set -e

trap 'exit 1' SIGINT
trap 'exit 1' SIGTERM

rm -r dist
mkdir -p dist

x64_configs=(
    "shredos_defconfig"
    "shredos_img_defconfig"
    "shredos_iso_defconfig"
	"shredos_iso_aio_defconfig"
)

x32_configs=(
    "shredos_i586_defconfig"
    "shredos_img_i586_defconfig"
    "shredos_iso_i586_defconfig"
	"shredos_iso_aio_i586_defconfig"
)

VERSION_FILE="board/shredos/fsoverlay/etc/shredos/version.txt"

x64_success=0
x64_failed=0
x32_success=0
x32_failed=0

replace_version() {
    local from=$1
    local to=$2
    if [ -f "$VERSION_FILE" ]; then
        sed -i "s/$from/$to/g" "$VERSION_FILE"
    fi
}

build_config() {
    local config=$1
    local arch=$2
    local log_file="dist/${config}.log"

    echo "============================================"
    echo "Building $config"
    echo "============================================"

    make clean
    make "$config"

	set +e
    make 2>&1 | tee "$log_file"
	local make_status=${PIPESTATUS[0]}
	set -e

    if [ $make_status -eq 0 ]; then
        mv "$log_file" "dist/${config}-OK.log"

        mkdir -p "dist/$config"
        mv output/images/shredos*.iso "dist/$config/" 2>/dev/null || true
        mv output/images/shredos*.img "dist/$config/" 2>/dev/null || true

        echo "--> $config build success"

        if [ "$arch" = "x64" ]; then
            ((x64_success++))
        else
            ((x32_success++))
        fi
        return 0
    else
        mv "$log_file" "dist/${config}-FAILED.log"

        echo "--> $config build failed"

        if [ "$arch" = "x64" ]; then
            ((x64_failed++))
        else
            ((x32_failed++))
        fi
        return 1
    fi
}

if [ ${#x64_configs[@]} -gt 0 ]; then
    echo "Starting x64 builds..."
    replace_version "i586" "x86-64"

    for config in "${x64_configs[@]}"; do
        build_config "$config" "x64"
    done
fi

if [ ${#x32_configs[@]} -gt 0 ]; then
    echo "Starting x32 builds..."
    replace_version "x86-64" "i586"

    for config in "${x32_configs[@]}"; do
        build_config "$config" "x32"
    done
fi

total_success=$((x64_success + x32_success))
total_failed=$((x64_failed + x32_failed))
total_builds=$((total_success + total_failed))

echo ""
echo "============================================"
echo "BUILD SUMMARY"
echo "============================================"
echo "x64 builds:  $x64_success succeeded, $x64_failed failed"
echo "x32 builds:  $x32_success succeeded, $x32_failed failed"
echo "--------------------------------------------"
echo "Total:       $total_success succeeded, $total_failed failed (out of $total_builds)"
echo "============================================"

if [ $total_failed -gt 0 ]; then
    exit 1
else
    exit 0
fi
