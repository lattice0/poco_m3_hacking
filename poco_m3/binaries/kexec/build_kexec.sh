set -ex
export TOOLCHAIN=${ANDROID_NDK_HOME}/toolchains/llvm/prebuilt/linux-x86_64
export TARGET=aarch64-linux-android
#minSdkVersion.
export API=28
export AR=$TOOLCHAIN/bin/llvm-ar
export CC=$TOOLCHAIN/bin/$TARGET$API-clang
export AS=$CC
export CXX=$TOOLCHAIN/bin/$TARGET$API-clang++
export LD=$TOOLCHAIN/bin/ld
export RANLIB=$TOOLCHAIN/bin/llvm-ranlib
export STRIP=$TOOLCHAIN/bin/llvm-strip
(cd kex && autoreconf && LDFLAGS=-static ./configure --host $TARGET && make)
# needed because of https://github.com/termux/termux-packages/issues/8273
./align_fix.py kex/build/sbin/kexec
#--sysroot=${ANDROID_NDK_HOME}/toolchains/llvm/prebuilt/linux-x86_64/sysroot/ 