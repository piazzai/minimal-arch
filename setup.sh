#!/bin/bash
set -e

# set timezone
timedatectl set-timezone $timezone
hwclock -wu

# generate locale
sed -i 's/^#$locale.UTF-8/$locale.UTF-8/' /etc/locale.gen
locale-gen
echo "LANG=$locale.UTF-8" > /etc/locale.conf

# set hostname
echo $hostname > /etc/hostname
cat << EOF >> /etc/hosts
  127.0.0.1   localhost
  ::1         localhost
  127.0.1.1   $hostname.localdomain   $hostname
EOF

# install bootloader
bootctl install

# create boot entry
cat << EOF > /boot/loader/entries/arch.conf
  title     Arch Linux
  linux     /vmlinuz-linux
  initrd    /initramfs-linux.img
  options   root=${device}3 rw
EOF

# configure bootloader
cat << EOF > /boot/loader/loader.conf
  default   arch
  timeout   0
  editor    no
EOF

# add sudo user
useradd -m -g users -G wheel -s /bin/bash $username
echo "$username:$password" | chpasswd
sed -i 's/^# %wheel ALL=(ALL:ALL) ALL$/%wheel ALL=(ALL:ALL) ALL/' /etc/sudoers

# install network manager
yes | pacman -S networkmanager

# enable network service
systemctl enable NetworkManager

# lock root
passwd -l root

# exit arch-chroot
exit
