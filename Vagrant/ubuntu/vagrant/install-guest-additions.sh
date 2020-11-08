#!/bin/bash
GUEST_ADDITION_VERSION=6.1.16
GUEST_ADDITION_ISO=VBoxGuestAdditions_${GUEST_ADDITION_VERSION}.iso
GUEST_ADDITION_MOUNT=/media/VBoxGuestAdditions

is_virtualbox_guest_utils_installed=$(lsmod | grep -i vboxguest)

if [ -z "$is_virtualbox_guest_utils_installed" ]
then
  apt-get remove --auto-remove virtualbox-guest-utils -y
fi

apt-get install linux-headers-"$(uname -r)" build-essential dkms -y

wget http://download.virtualbox.org/virtualbox/${GUEST_ADDITION_VERSION}/${GUEST_ADDITION_ISO}
mkdir -p ${GUEST_ADDITION_MOUNT}
mount -o loop,ro ${GUEST_ADDITION_ISO} ${GUEST_ADDITION_MOUNT}
sh ${GUEST_ADDITION_MOUNT}/VBoxLinuxAdditions.run
rm ${GUEST_ADDITION_ISO}
umount ${GUEST_ADDITION_MOUNT}
rmdir ${GUEST_ADDITION_MOUNT}
