NOOBSConfig - wifi example
==========================
This example demonstrates how you can configure your Raspbian wifi connection so that it works straight out of the box when Raspbian is installed. The method used in this example permits the wifi to be configured on the SD card using Windows. There are also alternative examples provided in the Helpers folder to configure the wifi on the RPi using simple scripts. 

This example assumes that the wifi dongle you use is directly supported by Raspbian. If the dongle is not supported, you may have to install a specific wifi driver or dongle firmware first.

Copying the files in this folder and below into the /os/Raspbian folder on your NOOBS recovery partition will install two wifi configuration files onto the RPi. You should edit them according to your wifi configuration before you copy them.

The files installed are `/etc/network/interfaces` and `/etc/wpa_supplicant/wpa_supplicant.conf` and these provide a very simple template for the common WPA/WPA2 wifi configuration. Simply replace the SSID and password settings in `wpa_supplicant.conf` to match your wifi setup. 

If you have a more complex setup, you can provide any additional settings or network configurations as you require.

