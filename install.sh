#!/bin/bash
set -e

# set variables
source arch.conf

# prompt confirmation
read -p "About to wipe $device. Proceed? (y/N) "
case $REPLY in
  [Yy]*) echo "Proceeding..." ; sleep 3 ;;
  *) echo "Aborted." ; exit ;;
esac

# wipe disk
wipefs -a $device

# create new signature
parted $device mklabel gpt

# create partitions
parted -a opt $device mkpart efi fat32 1MiB $((efisize + 1))MiB
parted -a opt $device mkpart swap linux-swap $((efisize + 1))MiB $((efisize + swapsize + 1))MiB
parted -a opt $device mkpart root ext4 $((efisize + swapsize + 1))MiB 100%

# set efi partition
parted $device set 1 esp on

# enable swap
mkswap ${device}2 && swapon ${device}2

# format partitions
mkfs.fat -F 32 ${device}1
yes | mkfs.ext4 ${device}3

# mount partitions
mount ${device}3 /mnt
mkdir /mnt/boot && mount ${device}1 /mnt/boot

# update clock
timedatectl set-ntp true

# install base packages
pacstrap /mnt base base-devel linux linux-firmware

# generate fstab
genfstab -U /mnt >> /mnt/etc/fstab

# export variables
export device
export hostname
export username
export password
export timezone
export locale

# run setup.sh as root
mkdir /mnt/march
cp -r ./* /mnt/march/
arch-chroot /mnt bash /march/setup.sh
rm -rf /mnt/march

# ask to reboot
read -p "Ready to reboot. Proceed? (Y/n) "
case $REPLY in
  [Nn]*) echo "Reboot postponed." ; exit ;;
  *) echo "Rebooting..." ; sleep 3 ;;
esac

# reboot
umount -R /mnt
reboot
