NOOBSConfig - helper scripts
===========

###Introduction###
This folder contains script files to help the user create a customised tarball to be installed with a standard NOOBS installation of Raspbian on a Raspberry Pi.
(They may also work with Arch, Pidora and RaspBMC, but these have not been tested yet)

I have also included an installation package in the examples\nc-helpers folder to install them with noobsconfig, which may be easier.

First you should use NOOBS to install the standard installation of Raspbian, then boot into the Raspbian OS.
The files in this repository folder should be copied to the /usr/local/bin directory in Raspbian so that they are available from anywhere.

* /usr/local/bin/nc-get-label
* /usr/local/bin/nc-set-wifi
* /usr/local/bin/nc-capture-wifi
* /usr/local/bin/nc-create-custom-tar
* /usr/local/bin/nc-create-custom-xz

You will need to make these executable as follows:

`cd /usr/local/bin`
`sudo chmod +x nc-*`

It is probably a good idea to to go back to your /home/pi directory before using these files using:
`$ cd ~`

###nc-get-label###
This script file determines the base filename of the tarball to be used, based on the name of OS flavour and partition names installed.
(It assumes the first partition is mapped to /boot).
With no arguments provided, it returns the name for the highest partition number, so `Raspbian_root` for Raspbian.
If you want the name of the tarball that should be used for the first partition, you can use `nc-get-label 1`, or `nc-get-label 2` for the second.
See `nc-set-wifi` for how to use this from within another script.

###nc-capture-wifi###
This script is used to capture the network and wifi settings after they have been setup by other means, either manually or using a program such as wpa_gui, wpa_cli etc.
It simply creates a text file containing the names of the files to be captured:
* /etc/network/interfaces
* /etc/wpa_supplicant/wpa_supplicant.conf

If your configuration requires additional files to be customised, add them manually to the generated text file.
This script uses `nc-get-label` to determine the name of the text file to create. If you want to use another name, just specify it as the first argument, but note that only tarballs with the appropriate name will be installed automatically.

Note that this script will APPEND data to the text file, without first deleting its contents. This allows it to be used in conjunction with other similar scripts to capture other file names that should be included in your customised OS.

###nc-create-custom-tar###
This script will take the list of files specified in a text file, and create a tarball comprising those files.
It uses `nc-get-label` to determine the name of the text file and the name of the resultant tarball (with .tar appended). If you want to use a different name, specify it as the first argument, but note that only tarballs with the appropriate name will be installed automatically.

This tar file can now be copied to your NOOBS /os/Raspbian directory to be installed during installation of a new copy of the OS.

###nc-create-custom-xz###
This script does exactly the same thing as `nc-create-custom-tar`, except it adds an extra step to compress the tarball using the XZ compression algorithm.
The resultant `filename.tar.xz` file can now be copied to your NOOBS /os/Raspbian directory to be installed during installation of a new copy of the OS.

###nc-set-wifi###
This is an example of a very simple script to setup the wifi and network configuration of a new installation.
It only supports WPA/WPA2 wifi networks, but it could be easily modified for other types.
On execution of this script it will ask for the wifi network ID (SSID) and the password. It will then create a temporary sample '/etc/network/interfaces' and a `/etc/wpa_supplicant/wpa_supplicant.conf` file. These will be archived into a `Raspbian_root.tar` file (using `nc-get-label`) ready for copying to the NOOBS /os/Raspbian folder.
Again, if you want to use a different name for the tar file, specify it as the 1st argument. But note that only customised tar files with the appropriate name will be installed automatically.

If you notice some strange settings at the end of `interfaces` relating to eth0:1, these were suggested by @Cymplecy to provide a default wired IP address. If you don't need them they can be safely deleted.