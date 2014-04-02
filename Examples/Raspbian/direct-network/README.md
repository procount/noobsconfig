Noobsconfig - Direct Network Connection
=======================================
Meltwater provides some excellent guides (http://pihw.wordpress.com/guides/direct-network-connection/super-easy-direct-network-connection/ and http://pihw.wordpress.com/guides/direct-network-connection/) on how to set up a direct wired connection to your RPi from a laptop or PC when you don't have a full network and no DHCP sever to provide IP addresses.

But at the time of writing, this was only possible if you installed a pure Raspbian image. NOOBS users had a problem since the Raspbian image was contained in a compressed tar file, so it was not easy to access the `cmdline.txt` file.

Noobsconfig provides as answer to this as it makes it possible to replace the `cmdline.txt` after the boot image has been written to the SD card.

Copying the files in this folder and below into the /os/Raspbian folder on your NOOBS recovery partition will give the RPi an IP address of 169.254.0.10
when you next boot into Raspbian after it is installed. If you want to use a different IP address, just edit the cmdline.txt file in the `direct` folder. 

In addition, the `network` folder contains Meltwater's original scripts. With these files copied onto the NOOBS recovery partition, you can edit the cmdline files in Windows to select the IP addresses you want to use for the different network modes: direct, internet or ICS. Still in Windows, you can execute the various WIN*.bat files to select which connection mode you want to use.

Noobsconfig will install the cmdline files and switchip.sh into the /boot/network folder of the installed Raspbian distro. So, after Raspbian is installed, you can use the /boot/network/switchip.sh script to change between the different connection modes on the RPi. Please see Meltwater's comprehensive guiides for more detail.