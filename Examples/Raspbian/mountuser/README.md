NOOBSConfig - MountUser script
==============================
This example provides a script that can be used to mount the additional Data_Partition created by NOOBS into Raspbian.

Copying the files in this folder into the /os/Raspbian folder on your NOOBS recovery partition will install the MountUser scripts into the /home/pi folder of Raspbian.

Exceute `./MountUser <folder>` in Raspbian to mount the Data_Partition to `<folder>`. If `<folder>` is not given, it will mount the Data_Partition to `/mnt/DATA` by default.

The mount is made permanent by updating /etc/fstab, so this script need only be executed once.
