# Poco M3 hacking container

A container for hacking the Poco M3 Android phone, based on [Android Hacking Container](https://github.com/lattice0/android_hacking_container).

## Customizing for your phone

Edit the `.sh` files inside to download the kernel for your phone, as well as the ROM, tools, etc. 

## Running

### Pure docker

```bash
docker build -t project - < Dockerfile
docker run -u "$(id -u):$(id -g)" -it -v /dev/bus/usb:/dev/bus/usb -v $PWD/.mount/.android:/home/dev/.android -v $PWD:/home/dev/project -e DEVICE="../../device" project /bin/bash
```

then do `source android_hacking_container/source_me.sh`

### VSCode's Devcontainer

Open this in VSCode's .devcontainer, then 

```bash
source android_hacking_container/source_me.sh
```

## Usb problems

If you have problems with udev rules, do outside the container

```bash
sudo nano /etc/udev/rules.d/51-android.rules
```

Then paste, but with your vendor and product numbers (check with `lsusb`)

```bash
SUBSYSTEM=="usb", ATTR{idVendor}=="22b8", ATTR{idProduct}=="2e81", MODE="0666", GROUP="plugdev"
```

Then

```bash
sudo udevadm control --reload-rules
```
