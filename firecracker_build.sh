set -eux
#(cd firecracker && cargo build --target aarch64-linux-android)
#(cd firecracker && cargo build --target x86_64-unknown-linux-gnu)
(cd firecracker/ && cargo ndk -t arm64-v8a build)

####------------- CONFIG
#TAP_DEV="fc-88-tap0"

# set up the kernel boot args
#MASK_LONG="255.255.255.252"
#MASK_SHORT="/30"
#FC_IP="169.254.0.21"
#TAP_IP="169.254.0.22"
#FC_MAC="02:FC:00:00:00:05"

KERNEL_BOOT_ARGS="ro console=ttyS0 noapic reboot=k panic=1 pci=off nomodules random.trust_cpu=on"
#KERNEL_BOOT_ARGS="${KERNEL_BOOT_ARGS} ip=${FC_IP}::${TAP_IP}:${MASK_LONG}::eth0:off"

# set up a tap network interface for the Firecracker VM to user
#ip link del "$TAP_DEV" 2> /dev/null || true
#ip tuntap add dev "$TAP_DEV" mode tap
#sysctl -w net.ipv4.conf.${TAP_DEV}.proxy_arp=1 > /dev/null
#sysctl -w net.ipv6.conf.${TAP_DEV}.disable_ipv6=1 > /dev/null
#ip addr add "${TAP_IP}${MASK_SHORT}" dev "$TAP_DEV"
#ip link set dev "$TAP_DEV" up

VMLINUX_BIN=/data/local/tmp/Image
ROOTFS=/data/local/tmp/rootfs.ext4

# make a configuration file (original script: https://jvns.ca/blog/2021/01/23/firecracker--start-a-vm-in-less-than-a-second/)
cat <<EOF > vmconfig.json
{
  "boot-source": {
    "kernel_image_path": "$VMLINUX_BIN",
    "boot_args": "$KERNEL_BOOT_ARGS"
  },
  "drives": [
    {
      "drive_id": "rootfs",
      "path_on_host": "$ROOTFS",
      "is_root_device": true,
      "is_read_only": false
    }
  ],
  "machine-config": {
    "vcpu_count": 2,
    "mem_size_mib": 1024
  }
}
EOF
####------------- END CONFIG

(
adb push firecracker/build/cargo_target/aarch64-linux-android/debug/firecracker /data/local/tmp && \
adb push vmconfig.json /data/local/tmp && \
adb push linux.git/arch/arm64/boot/Image /data/local/tmp && \
adb push rootfs.ext4 /data/local/tmp && \
adb shell "chmod +x /data/local/tmp/firecracker" && \
adb shell "RUST_LOG=trace /data/local/tmp/firecracker --no-api --config-file /data/local/tmp/vmconfig.json"
)
