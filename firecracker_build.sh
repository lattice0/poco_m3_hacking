#(cd firecracker && cargo build --target aarch64-linux-android)
#(cd firecracker && cargo build --target x86_64-unknown-linux-gnu)
(cd firecracker/ && cargo ndk -t arm64-v8a build)
(adb push firecracker/build/cargo_target/aarch64-linux-android/debug/firecracker /sdcard && \
adb shell su -c "cp /sdcard/firecracker /data/local" && \
adb shell su -c "chmod +x /data/local/firecracker" && \
adb shell su -c "/data/local/firecracker --help")