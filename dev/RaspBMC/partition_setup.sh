#!/bin/ash

# Let OSIRIS see what we are doing
set -x
# We really don't want automated fscking
tune2fs -c 0 $part2
# Temporary mounting directory
mkdir -p /tmp/mount

if [ -e /mnt/customise.sh ]; then /mnt/customise.sh; fi

# Fix the cmdline.txt
mount $part1 /tmp/mount
eval "sed -e s:/dev/mmcblk0p2:$part2: -i /tmp/mount/cmdline.txt"
umount /tmp/mount
# Wait
sync
# Fix the fstab
mount $part2 /tmp/mount
eval "sed -e s:/dev/mmcblk0p1:$part1: -i /tmp/mount/etc/fstab"
eval "sed -e s:/dev/mmcblk0p2:$part2: -i /tmp/mount/etc/fstab"
umount /tmp/mount
# Wait
sync


