#!/usr/bin/env bash

# 1. Основные настройки
KERNEL_DIR=$(pwd)
OUT_DIR="$KERNEL_DIR/out"
DEFCONFIG="sweet_defconfig" # Замени на имя твоего defconfig, если оно другое

# 2. Окружение сборки
export ARCH=arm64
export SUBARCH=arm64

# Укажи пути к твоим кросс-компиляторам/Clang, если используешь внешние
# export PATH="/path/to/clang/bin:$PATH"

echo "=========================================="
echo "=== Сборка ядра Android (out-of-tree) ==="
echo "=== Папка сборки: $OUT_DIR"
echo "=========================================="

# Создаём папку для сборки
mkdir -p "$OUT_DIR"

# 3. Генерация конфигурации
echo "--> Генерируем .config из $DEFCONFIG..."
make O="$OUT_DIR" ARCH=arm64 $DEFCONFIG

if [ $? -ne 0 ]; then
    echo "[!] Ошибка генерации defconfig!"
    exit 1
fi

# 4. Запуск компиляции
echo "--> Запускаем сборку ядра на $(nproc) потоках..."
make -j$(nproc) O="$OUT_DIR" \
    ARCH=arm64 \
    CROSS_COMPILE=aarch64-linux-gnu- \
    CROSS_COMPILE_ARM32=arm-linux-gnueabi-

# 5. Проверка результата
if [ -f "$OUT_DIR/arch/arm64/boot/Image.gz-dtb" ] || [ -f "$OUT_DIR/arch/arm64/boot/Image.gz" ]; then
    echo "=========================================="
    echo "=== [УСПЕХ] Ядро успешно собрано! ==="
    echo "=== Файл ядра лежит в: $OUT_DIR/arch/arm64/boot/"
    echo "=========================================="
else
    echo "=========================================="
    echo "=== [ОШИБКА] Сборка завершилась неудачей! ==="
    echo "=========================================="
    exit 1
fi
