set -ex
rm -rf linux.git
git clone https://github.com/torvalds/linux.git linux.git
cp example.config linux.git/.config
cd linux.git
git checkout v4.20
#make menuconfig
ARCH=arm64 CROSS_COMPILE=aarch64-linux-gnu- make CC=clang .config
ARCH=arm64 CROSS_COMPILE=aarch64-linux-gnu- make CC=clang -j$(nproc --all)