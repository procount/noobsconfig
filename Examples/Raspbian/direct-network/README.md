Noobsconfig - Direct Network Connection
=======================================
Meltwater provides some excellent guides (http://pihw.wordpress.com/guides/direct-network-connection/super-easy-direct-network-connection/ and http://pihw.wordpress.com/guides/direct-network-connection/) on how to set up a direct wired connection to your RPi from a laptop or PC when you don't have a full network and no DHCP sever to provide IP addresses.

But at the time of writing, this was only possible if you installed a pure Raspbian image. NOOBS users had a problem since the Raspbian image was contained in a compressed tar file, so it was not easy to access the `cmdline.txt` file.

Noobsconfig provides as answer to this as it makes it possible to replace the `cmdline.txt` after the boot image has been written to the SD card.

Copying the files in this folder and below into the /os/Raspbian folder on your NOOBS recovery partition will give the RPi an IP address of 169.254.69.69 when you next boot into Raspbian after it is installed. If you want to use a different IP address, just edit the cmdline.txt file in the direct-network folder. Please see Meltwater's guides for information on how to use additional IP parameters for the network connection.