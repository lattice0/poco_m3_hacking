# Poco M3 hacking container

Do

```bash
DEVICE=../../poco_m3
```

Then 

```bash
source android_hacking_container/source_me.sh
```

Also for udev rules:

```bash
sudo nano /etc/udev/rules.d/51-android.rules
```

Then paste

```bash
SUBSYSTEM=="usb", ATTR{idVendor}=="18d1", ATTR{idProduct}=="d00d", MODE="0666",>
```

Then

```bash
sudo udevadm control --reload-rules
```