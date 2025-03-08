# kobo-netbird

`kobo-netbird` lets you install and automatically run
[netbird](https://netbird.io/) on kobo e-readers and persist it through reboots.

## Supported Devices

- Kobo Libra Colour

This is the primary device used for testing. If you own a different Kobo device,
feel free to install and test the process. If you are able to successfully run
`netbird` after installation, please share your results!

## Installation

> [!NOTE] The version of netbird to install can be chosen by editing the
> `NETBIRD_VERSION` variable in `install-netbird.sh`.

1. Download this repo onto your kobo e-reader's onboard storage.
2. Make sure that your device is connected to the internet. Then telnet or SSH
   into your device and run `install-netbird.sh`.
3. After the installation, you'll be prompted to run `netbird up`. Do that and
   follow the instructions to authenticate your e-reader!

#### What does `netbird` need to run on Kobo e-readers?

1. TUN/TAP Driver

Netbird requires the **TUN/TAP** driver for network tunneling. If the driver is
not detected, the installation process installs and loads the driver as a kernel
module.

The module was built from the [Kobo Libra 2 kernel source
code](https://github.com/kobolabs/Kobo-Reader/tree/master/hw/imx6sll-libra2)
provided by Rakuten following the instructions at
[kobo-kernel-modules](https://github.com/jmacindoe/kobo-kernel-modules/tree/main/Kobo%20Mark%209%20-%20Libra%202)
repo.

2. nftables

Netbird relies on **nftables** for connection handling. The installation process
deploys compatible **nftables** binaries along with their shared libraries to
the device. These binaries are sourced from **Debian snapshots**, ensuring
compatibility with the **glibc version** installed on the Libra Color.

3. Certificate Authority (CA) Store

For self-hosted Netbird deployments, **TLS certificates** from authorities like
**Let’s Encrypt** are commonly used. To ensure proper certificate validation,
the installation script retrieves and installs the latest **Mozilla CA
certificate bundle**.

## Uninstallation

Telnet or SSH into your device and run `uninstall-netbird.sh`. All files
provided by `kobo-netbird` and `netbird` including configs, logs and
dependencies will be removed from your device.

## Acknowledgements

- [videah](https://github.com/videah/kobo-tailscale) – For the project
  `kobo-tailscale` which served as the idea and foundation for `kobo-netbird`.
- [Dylan Staley](https://dstaley.com/posts/tailscale-on-kobo-sage) – For
  detailed guidance on running Tailscale on the Kobo Sage.
- [jmacindoe](https://github.com/jmacindoe/kobo-kernel-modules) – For
  documenting the process of compiling kernel modules for Kobo e-readers.
