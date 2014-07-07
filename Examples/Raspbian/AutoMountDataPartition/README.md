NOOBSConfig - AutoMountDataPartition script
===========================================
This example provides a script that can be used to mount the additional Data_Partition created by NOOBS into Raspbian.

Copying the files in this folder into the /os/Raspbian folder on your NOOBS recovery partition will install the AutoMountDataPartition script into the /home/pi folder of Raspbian.

Exceute `./AutoMountDataPartition <folder> <fstype>` in Raspbian to mount the Data_Partition to `<folder>`. If `<folder>` is not given, it will mount the Data_Partition to `/mnt/DATA` by default. You can optionally specify the filesystem type of the data partion as the 2nd argument. If none is given, it is assumed to be `ext4`.

The mount is made permanent by updating /etc/fstab, so this script need only be executed once.
