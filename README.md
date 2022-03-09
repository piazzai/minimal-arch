# minimal-arch

These are my scripts for a minimal [Arch Linux](https://www.archlinux.org) installation on a 64-bit system. A configuration file allows you to specify hard drive, space for EFI and swap partitions, hostname, username, password, timezone, and locale. The scripts then wipe the drive, create new partitions, and configure the OS according to your settings.

The installation will be a pure command-line environment with the (meta)packages [base](https://archlinux.org/packages/core/any/base/), [base-devel](https://archlinux.org/groups/x86_64/base-devel/), [linux](https://archlinux.org/packages/core/x86_64/linux/), [linux-firmware](https://archlinux.org/packages/core/any/linux-firmware/), [networkmanager](https://archlinux.org/packages/extra/x86_64/networkmanager/), and their dependencies. Everything else is up to you.

## Usage

Before installing, it is recommended to read the [official installation guide](https://wiki.archlinux.org/title/Installation_guide) to learn what the scripts are doing. It is assumed that you already have a bootable installation medium: if not, follow steps 1.1 through 1.4 of the official guide.

After booting from the installation medium, you should connect to a network. If you have a wired connection, it should work automatically; otherwise, you can authenticate into a wireless network using [iwctl](https://man.archlinux.org/man/iwctl). Substitute `$ssid` and `$pass` for the name and password of your network:

```sh
iwctl station wlan0 connect $ssid -P $pass
```

At this point you need to retrieve the installation scripts. Use `curl` to download them from this repository:

```sh
curl -O https://raw.githubusercontent.com/piazzai/minimal-arch/master/arch.conf
curl -O https://raw.githubusercontent.com/piazzai/minimal-arch/master/install.sh
curl -O https://raw.githubusercontent.com/piazzai/minimal-arch/master/setup.sh
```

Use [nano](https://man.archlinux.org/man/nano) to open `arch.conf` and edit it according to your needs. Then, type `bash install.sh` to start the installation process. The script will prompt a reboot at the end of the process, allowing you to disconnect the installation medium and boot into your new OS as a [sudo](https://man.archlinux.org/man/sudo) user.

After logging in with your username and password, access the wireless network with [nmcli](https://man.archlinux.org/man/nmcli):

```sh
sudo nmcli device wifi connect $ssid password $pass
```

You can now use [pacman](https://man.archlinux.org/man/pacman) to install whatever you need.
