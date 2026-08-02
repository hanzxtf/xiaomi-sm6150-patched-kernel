# 🚀 Kirill Kernel

Custom Android Linux Kernel for Xiaomi Redmi Note 10 Pro / Pro Max (`sweet` / `sweetin`)

Built on LineageOS kernel sources with additional integrations including KernelSU-Next, SUSFS, and Kali NetHunter compatibility patches.

![Linux](https://img.shields.io/badge/Linux-4.14-blue?style=for-the-badge)
![Android](https://img.shields.io/badge/Android-16-green?style=for-the-badge)
![ARM64](https://img.shields.io/badge/Architecture-ARM64-orange?style=for-the-badge)
![CachyOS](https://img.shields.io/badge/Built%20On-CachyOS-purple?style=for-the-badge)

---

# 📱 Supported Device

| Device | Codename |
|----------|----------|
| Redmi Note 10 Pro | sweet |
| Redmi Note 10 Pro Max | sweetin |

---

# ✨ Included Features

## Root & Security

- KernelSU-Next
- SUSFS
- Android 16 compatibility
- Root management improvements

## Kali NetHunter Compatibility

Enabled support for:

- Monitor Mode
- Packet Injection
- WEXT
- HID Keyboard
- HID Mouse
- USB Gadget
- External Wi-Fi Adapters

These features are intended for:

- Security Research
- Wireless Auditing
- Educational Use
- Network Analysis

## Performance

- LLVM / Clang builds
- ARM64 optimization
- Stable daily-driver configuration

---

# ⚠️ Before Flashing

Always backup:

```text
boot
dtbo
```

Recommended recoveries:

- OrangeFox
- TWRP

If a bootloop occurs:

1. Boot Recovery
2. Restore boot
3. Restore dtbo
4. Reboot

---

# 🏗 Repository Layout

```text
.
├── anykernel3/          Flashable ZIP packaging
├── arch/                CPU architecture code
├── block/               Block layer
├── certs/               Kernel certificates
├── crypto/              Cryptography subsystem
├── Documentation/       Kernel documentation
├── drivers/             Hardware drivers
├── firmware/            Firmware blobs
├── fs/                  Filesystems
├── include/             Kernel headers
├── init/                Boot initialization
├── ipc/                 Interprocess communication
├── kernel/              Core kernel code
├── KernelSU-Next/       KernelSU integration
├── lib/                 Common libraries
├── mm/                  Memory management
├── net/                 Networking stack
├── samples/             Sample code
├── scripts/             Build scripts
├── security/            Security subsystem
├── sound/               Audio subsystem
├── techpack/            Qualcomm techpack
├── tools/               Development tools
├── usr/                 Userspace support
├── virt/                Virtualization

├── build.sh             Main build script
├── Makefile             Kernel build system
├── Kconfig              Kernel configuration
├── COPYING              GPL License
└── README.md
```

---

# 🔨 Building

## Arch Linux / CachyOS

```bash
sudo pacman -S --needed \
base-devel \
clang \
llvm \
lld \
git \
bc \
bison \
flex \
cpio \
zip \
unzip \
perl \
python \
aarch64-linux-gnu-gcc \
arm-none-eabi-gcc
```

## Ubuntu / Debian

```bash
sudo apt update

sudo apt install -y \
build-essential \
clang \
llvm \
lld \
git \
bc \
bison \
flex \
cpio \
zip \
unzip \
perl \
python3 \
gcc-aarch64-linux-gnu \
gcc-arm-none-eabi
```

## Fedora

```bash
sudo dnf install -y \
clang \
llvm \
lld \
git \
bc \
bison \
flex \
cpio \
zip \
unzip \
perl \
python3 \
gcc-aarch64-linux-gnu \
arm-none-eabi-gcc
```

---

# 🚀 Compile

Clone:

```bash
git clone https://github.com/YOUR_USERNAME/android_kernel_xiaomi_sm6150.git
cd android_kernel_xiaomi_sm6150
```

Build:

```bash
chmod +x build.sh
./build.sh
```

Result:

```text
Image.gz-dtb
dtbo.img
Flashable ZIP
```

Example output:

```text
KIRILLS_KERNEL_YYYYMMDD_HHMM.zip
```

---

# 📦 Flashing

```bash
adb reboot recovery
```

Flash generated ZIP via:

- OrangeFox
- TWRP

Reboot system after installation.

---

# 🧩 Main Components

| Component | Description |
|------------|------------|
| KernelSU-Next | Kernel root solution |
| SUSFS | Mount and namespace hiding |
| AnyKernel3 | ZIP installer framework |
| Clang/LLVM | Build toolchain |
| Qualcomm Techpack | Vendor drivers |
| NetHunter Patches | Security research functionality |

---

# 🤝 Credits

This project integrates work from many open-source developers.

Special thanks:

- LineageOS Team
- Linux Kernel Contributors
- KernelSU Team
- KernelSU-Next Developers
- SUSFS Developers
- Kali NetHunter Team
- Offensive Security
- osm0sis (AnyKernel3)
- devestrog (modify kernel)
- kalilinux 

Additional patches and integrations were adapted from community-maintained Android kernel projects where applicable.

---

# 👨‍💻 Maintainer

Kirill

Responsibilities:

- Kernel integration
- Build automation
- KernelSU-Next integration
- SUSFS integration
- NetHunter compatibility work
- LLVM/Clang support
- Testing on CachyOS

---

# 📜 License

Licensed under GPLv2.

See:

```text
COPYING
```

for details.

---

# ⚖️ Disclaimer

Flash at your own risk.

The maintainer is not responsible for:

- Data loss
- Bootloops
- Device damage
- Software issues

Always keep backups of boot and dtbo partitions.

# Patched Components

- KernelSU-Next
- SUSFS
- Kali NetHunter patches
- AnyKernel3 packaging
- Custom build automation
