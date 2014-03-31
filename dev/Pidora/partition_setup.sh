#!/bin/bash

if [[ ${part1} == '' || ${part2} == '' ]]; then
    echo "error: part1 and part2 not specified"
    exit 1
fi

# create mount points
mkdir /tmp/1
mkdir /tmp/2

# mount partitions
mount ${part1} /tmp/1
mount ${part2} /tmp/2

if [ -e /mnt/customise.sh ]; then /mnt/customise.sh; fi

# adjust files
sed -ie "s|root=/dev/mmcblk0p[0-9]|root=${part2}|" /tmp/1/cmdline.txt
sed -ie "s|^.* / |${part2}      / |" /tmp/2/etc/fstab
sed -ie "s|^.* /boot |${part1}      /boot |" /tmp/2/etc/fstab

# clean up
umount /tmp/1
umount /tmp/2


