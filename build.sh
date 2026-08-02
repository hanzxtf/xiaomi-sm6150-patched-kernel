#!/usr/bin/env bash
set -e

# ==========================================
# Настройки окружения и путей
# ==========================================
KERNEL_DIR=$(pwd)
OUT_DIR="$KERNEL_DIR/out"
AK3_DIR="$KERNEL_DIR/anykernel3"
KERNEL_NAME="NS-KERNEL"
DEFCONFIG="sweet_defconfig"
ZIP_NAME="KIRILLS_KERNEL_$(date +%Y%m%d_%H%M).zip"

export ARCH=arm64
export SUBARCH=arm64

# Флаги Clang для корректной сборки под aarch64
CLANG_FLAGS="--target=aarch64-linux-gnu"
export KCFLAGS="$CLANG_FLAGS -Wno-implicit-enum-enum-cast -Wno-enum-enum-conversion -Wno-error=implicit-function-declaration -Wno-error=implicit-int -Wno-error"

echo "=========================================="
echo "=== [1/4] Очистка старых архивов       ==="
echo "=========================================="
mkdir -p "$OUT_DIR"
rm -rf "${AK3_DIR}/Image.gz-dtb" "${AK3_DIR}"/*.zip

echo "=========================================="
echo "=== [2/4] Сборка ядра на Clang (LLVM=1) ==="
echo "=========================================="
echo "--> Генерируем .config из $DEFCONFIG..."
make O="$OUT_DIR" ARCH=arm64 LLVM=1 "$DEFCONFIG"

echo "--> Запускаем сборку ядра на $(nproc) потоках..."
make -j$(nproc) O="$OUT_DIR" \
  ARCH=arm64 \
  LLVM=1 \
  LLVM_IAS=1 \
  LOCALVERSION="$KERNEL_NAME" \
  CLANG_TRIPLE=aarch64-linux-gnu- \
  CROSS_COMPILE=aarch64-linux-gnu- \
  CROSS_COMPILE_ARM32=arm-linux-gnueabi-

echo "=========================================="
echo "=== [3/4] Склейка Image.gz и DTB        ==="
echo "=========================================="
IMAGE_GZ="$OUT_DIR/arch/arm64/boot/Image.gz"
DTB="$OUT_DIR/arch/arm64/boot/dts/qcom/xiaomi-sdmmagpie.dtb"

if [ -f "$IMAGE_GZ" ] && [ -f "$DTB" ]; then
  cat "$IMAGE_GZ" "$DTB" >"${AK3_DIR}/Image.gz-dtb"
  echo "--> Image.gz-dtb успешно сформирован!"
else
  echo "[!] ОШИБКА: Не найден $IMAGE_GZ или $DTB!"
  exit 1
fi

echo "=========================================="
echo "=== [4/4] Упаковка в AnyKernel3 ZIP     ==="
echo "=========================================="
cd "$AK3_DIR"
zip -r9 "../$ZIP_NAME" . -x ".git/*" "README.md" "*placeholder*"
cd "$KERNEL_DIR"

echo "=========================================="
echo "=== [УСПЕХ] Готовый архив ядра собрался: ==="
echo ">>> $KERNEL_DIR/$ZIP_NAME <<<"
echo "=========================================="

# Удаляем временный Image.gz-dtb из папки AnyKernel3
rm -f "${AK3_DIR}/Image.gz-dtb"

# Интерактивное предложение очистить папку out/
read -p "Желаешь удалить артефакты сборки из папки out/? (y/N): " choice
case "$choice" in
[yY][eE][sS] | [yY])
  echo "--> Очистка $OUT_DIR..."
  rm -rf "$OUT_DIR"
  echo "Папка out/ успешно очищена!"
  ;;
*)
  echo "Папка out/ сохранена для инкрементальной (быстрой) пересборки."
  ;;
esac
