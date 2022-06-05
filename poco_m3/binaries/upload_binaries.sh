set -ex
adb push ./kexec/kex/build/sbin/kexec /data/local/tmp
adb shell "chmod +x /data/local/tmp/kexec"