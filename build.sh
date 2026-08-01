#!/usr/bin/env bash

KERNEL_DIR=$(pwd)
OUT_DIR="$KERNEL_DIR/out"
DEFCONFIG="sweet_defconfig"

export ARCH=arm64
export SUBARCH=arm64

# Указываем Clang строго целевую архитектуру aarch64 для избежания ошибок с "sp"
CLANG_FLAGS="--target=aarch64-linux-gnu"
export KCFLAGS="$CLANG_FLAGS -Wno-implicit-enum-enum-cast -Wno-enum-enum-conversion -Wno-error=implicit-function-declaration -Wno-error=implicit-int -Wno-error"

echo "=========================================="
echo "=== Сборка ядра на Clang (LLVM=1)      ==="
echo "=== Папка сборки: $OUT_DIR"
echo "=========================================="

mkdir -p "$OUT_DIR"

echo "--> Генерируем .config из $DEFCONFIG..."
make O="$OUT_DIR" ARCH=arm64 LLVM=1 $DEFCONFIG

if [ $? -ne 0 ]; then
    echo "[!] Ошибка генерации defconfig!"
    exit 1
fi

echo "--> Запускаем сборку ядра на $(nproc) потоках..."
make -j$(nproc) O="$OUT_DIR" \
    ARCH=arm64 \
    LLVM=1 \
    LLVM_IAS=1 \
    CLANG_TRIPLE=aarch64-linux-gnu- \
    CROSS_COMPILE=aarch64-linux-gnu- \
    CROSS_COMPILE_ARM32=arm-linux-gnueabi-

if [ -f "$OUT_DIR/arch/arm64/boot/Image.gz-dtb" ] || [ -f "$OUT_DIR/arch/arm64/boot/Image.gz" ]; then
    echo "=========================================="
    echo "=== [УСПЕХ] Ядро успешно собрано! ==="
    echo "=== Файл ядра: $OUT_DIR/arch/arm64/boot/Image.gz-dtb"
    echo "=========================================="
else
    echo "=========================================="
    echo "=== [ОШИБКА] Сборка завершилась неудачей! ==="
    echo "=========================================="
    exit 1
fi
