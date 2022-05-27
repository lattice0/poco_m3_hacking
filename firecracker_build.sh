#(cd firecracker && cargo build --target aarch64-linux-android)
(cd firecracker && cargo build --target x86_64-unknown-linux-gnu)
(cd firecracker && cargo ndk -t arm64-v8a build --target aarch64-linux-android)