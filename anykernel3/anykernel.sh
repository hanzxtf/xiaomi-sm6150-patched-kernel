# AnyKernel3 Setup
properties() {
  kernel.string=KernelSU-Next SUSFS Kernel by Kirill
  do.devicecheck=1
  do.modules=0
  do.systemless=1
  do.cleanup=1
  do.cleanuntil=0
  device.name1=sweet
  device.name2=sweetin
}

block=/dev/block/bootdevice/by-name/boot
is_slot_device=0
ramdisk_compression=auto

dump_boot

write_boot

## end install
