NOOBSConfig - Zero config wifi - Quickstart
==============================

This file explains how to very quickly configure your NOOBS Raspbian installation to connect to your wifi on first boot. It assumes your wifi dongle is supported by Raspbian.

1. On your PC, format your SD card to full capacity.
2. Unzip/copy the standard NOOBS installation files onto it, as per the standard instructions.
3. Unzip/copy the noobsconfig.zip to the root of your SD card, overwriting any existing files.
Your NOOBS SD card is now modified to support customisations!
4. From the Examples\Raspbian\wifi folder of this repository, copy the Raspbian_root.txt and the wifi folder to the \os\distro\Raspbian folder of your SD card.
5. Edit the \os\distro\Raspbian\wifi\wpa_supplicant.conf file and replace "MyNetwork" with the SSID name of your wifi network and "MyPassword"  with your wifi network's password or key.
6. Insert your SD card in the RPi and install Raspbian.

After Raspbian is installed the Rpi will then reboot into Raspbian as usual, except now it should be configured to automatically connect to your WPA/WPA2 wifi network using DHCP.

If your networking needs are different, simply modify the interfaces and wpa_supplicant.conf files accordingly before installation.


