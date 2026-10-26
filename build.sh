#!/usr/bin/env bash
set -e

KERNEL_DIR=$(pwd)
OUT_DIR="$KERNEL_DIR/out"
AK3_DIR="$KERNEL_DIR/anykernel3"
DEFCONFIG="vendor/sdmsteppe-perf_defconfig"
FRAGMENT="arch/arm64/configs/vendor/sweet.config"
ZIP_NAME="HANZXTF_KERNEL_$(date +%Y%m%d_%H%M).zip"

export ARCH=arm64
export SUBARCH=arm64

CLANG_FLAGS="--target=aarch64-linux-gnu"
export KCFLAGS="$CLANG_FLAGS -Wno-implicit-enum-enum-cast -Wno-enum-enum-conversion -Wno-error=implicit-function-declaration -Wno-error=implicit-int -Wno-error"

echo "=========================================="
echo "=== [1/4] Cleaning old artifacts       ==="
echo "=========================================="
mkdir -p "$OUT_DIR"
rm -f "$AK3_DIR"/Image.gz "$AK3_DIR"/Image.gz-dtb "$AK3_DIR"/*.zip

echo "=========================================="
echo "=== [2/4] Generating config           ==="
echo "=========================================="
echo "--> $DEFCONFIG + $(basename "$FRAGMENT")"
make O="$OUT_DIR" ARCH=arm64 LLVM=1 "$DEFCONFIG"
scripts/kconfig/merge_config.sh -O "$OUT_DIR" "$OUT_DIR/.config" "$FRAGMENT" >/dev/null
make O="$OUT_DIR" ARCH=arm64 LLVM=1 olddefconfig

echo "=========================================="
echo "=== [3/4] Building on $(nproc) threads ==="
echo "=========================================="
make -j"$(nproc)" O="$OUT_DIR" \
  ARCH=arm64 \
  LLVM=1 \
  LLVM_IAS=1 \
  CLANG_TRIPLE=aarch64-linux-gnu- \
  CROSS_COMPILE=aarch64-linux-gnu-

echo "=========================================="
echo "=== [4/4] Packaging the AnyKernel3 ZIP ==="
echo "=========================================="
IMAGE_GZ="$OUT_DIR/arch/arm64/boot/Image.gz"

if [ ! -f "$IMAGE_GZ" ]; then
  echo "[!] ERROR: missing $IMAGE_GZ"
  exit 1
fi

# Plain Image.gz on purpose: the boot image keeps the ROM's own dtb section,
# exactly like the stock boot image, instead of appending a second dtb.
cp "$IMAGE_GZ" "$AK3_DIR/Image.gz"

cd "$AK3_DIR"
zip -qr9 "../$ZIP_NAME" . -x ".git/*" "README.md"
cd "$KERNEL_DIR"
rm -f "$AK3_DIR/Image.gz"

echo "=========================================="
echo "=== [DONE] Kernel archive built:       ==="
echo ">>> $KERNEL_DIR/$ZIP_NAME <<<"
echo "=========================================="
