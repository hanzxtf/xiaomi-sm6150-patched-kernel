#!/usr/bin/env bash
set -e

# ==========================================
# Environment and paths
# ==========================================
KERNEL_DIR=$(pwd)
OUT_DIR="$KERNEL_DIR/out"
AK3_DIR="$KERNEL_DIR/anykernel3"
DEFCONFIG="sweet_defconfig"
ZIP_NAME="HANZXTF_KERNEL_$(date +%Y%m%d_%H%M).zip"

export ARCH=arm64
export SUBARCH=arm64

# Clang flags for a correct aarch64 build
CLANG_FLAGS="--target=aarch64-linux-gnu"
export KCFLAGS="$CLANG_FLAGS -Wno-implicit-enum-enum-cast -Wno-enum-enum-conversion -Wno-error=implicit-function-declaration -Wno-error=implicit-int -Wno-error"

echo "=========================================="
echo "=== [1/4] Cleaning old archives       ==="
echo "=========================================="
mkdir -p "$OUT_DIR"
rm -rf "${AK3_DIR}/Image.gz-dtb" "${AK3_DIR}"/*.zip

echo "=========================================="
echo "=== [2/4] Building the kernel with Clang (LLVM=1) ==="
echo "=========================================="
echo "--> Generating .config from $DEFCONFIG..."
make O="$OUT_DIR" ARCH=arm64 LLVM=1 "$DEFCONFIG"

echo "--> Building on $(nproc) threads..."
make -j$(nproc) O="$OUT_DIR" \
  ARCH=arm64 \
  LLVM=1 \
  LLVM_IAS=1 \
  CLANG_TRIPLE=aarch64-linux-gnu- \
  CROSS_COMPILE=aarch64-linux-gnu- \
  CROSS_COMPILE_ARM32=arm-linux-gnueabi-

echo "=========================================="
echo "=== [3/4] Concatenating Image.gz and DTB  ==="
echo "=========================================="
IMAGE_GZ="$OUT_DIR/arch/arm64/boot/Image.gz"
DTB="$OUT_DIR/arch/arm64/boot/dts/qcom/xiaomi-sdmmagpie.dtb"

if [ -f "$IMAGE_GZ" ] && [ -f "$DTB" ]; then
  cat "$IMAGE_GZ" "$DTB" >"${AK3_DIR}/Image.gz-dtb"
  echo "--> Image.gz-dtb created"
else
  echo "[!] ERROR: missing $IMAGE_GZ or $DTB!"
  exit 1
fi

echo "=========================================="
echo "=== [4/4] Packaging the AnyKernel3 ZIP  ==="
echo "=========================================="
cd "$AK3_DIR"
zip -r9 "../$ZIP_NAME" . -x ".git/*" "README.md" "*placeholder*"
cd "$KERNEL_DIR"

echo "=========================================="
echo "=== [DONE] Kernel archive built: ==="
echo ">>> $KERNEL_DIR/$ZIP_NAME <<<"
echo "=========================================="

# Remove the temporary Image.gz-dtb from AnyKernel3
rm -f "${AK3_DIR}/Image.gz-dtb"

# Ask whether to clean the out/ directory
read -p "Delete build artifacts in out/? (y/N): " choice
case "$choice" in
[yY][eE][sS] | [yY])
  echo "--> Cleaning $OUT_DIR..."
  rm -rf "$OUT_DIR"
  echo "out/ cleaned"
  ;;
*)
  echo "out/ kept for incremental rebuilds."
  ;;
esac
