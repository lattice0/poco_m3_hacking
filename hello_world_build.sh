(cd hello_world/ && cargo ndk -t arm64-v8a build)
(adb push hello_world/target/aarch64-linux-android/debug/hello_world /sdcard && \
adb shell su -c "cp /sdcard/hello_world /data/local" && \
adb shell su -c "chmod +x /data/local/hello_world" && \
adb shell su -c "/data/local/hello_world")