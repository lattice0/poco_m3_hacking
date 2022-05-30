#!/usr/bin/env bash
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

set -xe
cd k
PATH="${PATH}:$SCRIPT_DIR/../tools/clang/bin:$SCRIPT_DIR/../tools/gcc/toolchain/bin"
export ARCH=arm64 && export SUBARCH=arm64
#export CROSS_COMPILE=/opt/aosp_prebuilts/aarch64-linux-android-4.9/bin/aarch64-linux-android-
export CROSS_COMPILE=aarch64-linux-android-
#TODO: why this?
export DTC_EXT="/opt/google_misc/misc/linux-x86/dtc/dtc"
clang -v
mkdir -p out
#EXTRA_CONFIGS="CONFIG_HAVE_KVM=y CONFIG_KVM=m CONFIG_KVM_ARM_HOST=y CONFIG_KVM_MMIO=y CONFIG_HAVE_KVM_IRQFD=y CONFIG_PREEMPT_NOTIFIERS=y CONFIG_HAVE_KVM_EVENTFD=y CONFIG_KVM_VFIO=y CONFIG_MMU_NOTIFIER=y KVM_ARCH_WANT_MMU_NOTIFIER=y CONFIG_HAVE_KVM_IRQ_ROUTING=y CONFIG_HAVE_KVM_IRQCHIP=y CONFIG_HAVE_KVM_ARCH_TLB_FLUSH_ALL=y CONFIG_KVM_GENERIC_DIRTYLOG_READ_PROTECT=y"
#EXTRA_KVM_FLAGS="-DCONFIG_KVM_MMIO -DCONFIG_KVM_ARM_HOST -DCONFIG_PREEMPT_NOTIFIERS -DCONFIG_HAVE_KVM_IRQFD -DCONFIG_HAVE_KVM_EVENTFD -DCONFIG_KVM_VFIO -DCONFIG_MMU_NOTIFIER -DCONFIG_HAVE_KVM_IRQ_ROUTING -DCONFIG_HAVE_KVM_IRQCHIP -DCONFIG_HAVE_KVM_ARCH_TLB_FLUSH_ALL -DCONFIG_KVM_GENERIC_DIRTYLOG_READ_PROTECT"
EXTRA_CONFIGS=""
EXTRA_KVM_FLAGS="" 
make O=out ${EXTRA_CONFIGS} ARCH=arm64 CC=clang CLANG_TRIPLE=aarch64-linux-gnu- vendor/citrus-perf_defconfig
make O=out ${EXTRA_CONFIGS} ARCH=arm64 CC=clang CLANG_TRIPLE=aarch64-linux-gnu- EXTRA_CFLAGS="${EXTRA_KVM_FLAGS} -fmacro-backtrace-limit=0 -I $PWD/techpack/display/pll/ -I $PWD/techpack/camera/drivers/cam_sensor_module/cam_cci/  -I $PWD/techpack/camera/drivers/cam_req_mgr -DSDCARDFS_VERSION= -I $PWD/"  -j$(nproc --all) 2>&1 | tee kernel.log
