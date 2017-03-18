noobsconfig
===========

Allows you to customise the installation of a NOOBS distro installation

## Introduction
This repository contains files to customise the installation of a standard NOOBS distro installation on a Raspberry Pi.

After NOOBS installs the standard boot and root images to the SD card, this modification allows a custom set of files to be copied, decompressed and extracted onto each partition of the distro being installed.

Please note: this will only work with the standard version of NOOBS and not with NOOBS-lite. It will not work with raw image files like RISC_OS.

A quick description of how to use this is followed by a more detailed description below.


## Quick Start
1. Unzip/copy the standard NOOBS files to a blank SD card.
2. Unzip/copy the noobsconfig.zip over the top of the noobs files. (This will overwrite the partition_setup.sh files for each of the os distros).
Your NOOBS SD card is now modified to support customisations!
3. Put any customisation files in the /os/distro folders.
4. Insert your SD card in the RPi and install the desired OS as usual

### Customisation Files

First, a brief explanantion about `flavours`.
For each distro NOOBS allows different `flavours`, which allow the same distro to be installed, but with slightly different customised options that are applied on first boot. Currently this feature is only used on Raspbian to allow booting into the desktop or straight to scratch, but it could be applied to any distro. In this documentation I use `flavour` to represent the "os name or flavour name". Typically a flavour name is the os name appended with a dash and the flavour. See `flavours.json` if it exists for your distro.

Three types of customisation files can be used. They must all have the same base filename of `(flavour)_(partitionName)` and differ in the three extensions that may be used:
* `(flavour)_(partitionName).tar`
* `(flavour)_(partitionName).tar.xz`
* `(flavour)_(partitionName).txt`

(Any spaces in the flavour or partitionName should be replaced by underscores)
The above files can be used individually or in combination. If more than one is found they are processed in the above order. They should be placed in the os/(distro) folder.
The .tar file will be un-tarred to the root of the appropriate partition.
The .xz file is assumed to be a compressed tar file and is treated in the same way after decompression.
The .txt file is used to install a list of files, each one on a separate line. These are described in more detail in Advanced Customisations below.

### Repository Organisation
* noobsconfig - contains noobsconfig.zip to allow customisations to be made to a distro
* dev - contains the contents of noobsconfig.zip
* helpers - contains helper scripts to help create custom tarballs
* Examples - contains example customisations

## Detailed Description

### What can it be used for?
This method is for simple customisations of a distro. It behaves a bit like applying a patch file to the distro after it has been installed.
As such it can replace or add files to the distro, but not delete existing files.
Some examples of its use are therefore:
* setting up wifi so that it works "out of the box" (maybe useful for schools etc)
* installing script files to install other packages (either manually or on first boot - like raspi-config)
* provide standard configurations for config.txt (instead of requiring raspi-config to be executed on first execution)
* install a standard set of "lesson support materials" into the `/home/pi` folder.

### Benefits
* ideal for small customisations
* does not require the creation of a full customised OS
* independent of NOOBS distributions
* Simple to apply to the standard NOOBS download
* the same customisations can be quickly and easily applied to a subsequent update of the NOOBS download

### What it doesn't do
Currently it does not execute user-defined scripts, it simply copies/replaces existing files.
Whilst it could be used to copy entire packages onto the distro, this use is not recommended and it is suggested to follow the existing instructions to create a customised OS if the modifications are extensive.

### Rationale
I like to use the latest version of NOOBS whenever it is released, ensuring I get all the latest updates and distro versions.
However, whenever I update to a new version, or reinstall a distro from NOOBS, I end up having to apply the same customisations and installations over and over again.
I've now learnt to create scripts for these common operations and a custom tarball that I can use to overwrite files like `/etc/network/interfaces` etc.
But it's still an extra step to perform after NOOBS has finished. So I thought about how this could be applied automatically.

From a simple enhancement suggestion, this has developed from extracting a tarball, to decompressing xz files, copying single files and setting owner and permission attributes for all distros and flavours. 

The ability to patch using a flavour would be ideal for schools and others, it could save building full custom images and avoids having to rebuild it for every new release of Raspbian. It would also allow Zero-config setups, for instance you'd be able to configure NOOBS to auto-install a distro which has direct wifi networking enabled out of the box.
 
## How does the noobsconfig customisation work?

After noobs has installed a distro, it runs the `partition_setup.sh` script for that distro.
Unzipping noobsconfig.zip over noobs replaces the partition_setup.sh files with a new version that adds a single line that executes customise.sh. This customise.sh script looks for files in the distro folder with a basename of (flavour)_(partitionName) and an extension of either `.tar`, `.tar.xz` or `.txt`. (The contents of noobsconfig.zip can be found in the `dev` folder.)

Note that `(flavour)` and `(partitionName)` must exactly match (in characters and case) the names provided in the `*.json` files that describe each OS in order for them to be recognised. Any spaces should be replaced with underscores.
So, for the standard v1.3.4 installation of noobs, the following base filenames are valid:
<pre>
Arch_boot
Arch_root
Data_Partition_data
OpenELEC_Storage
OpenELEC_System
Pidora_boot
Pidora_rootfs
Raspbian_boot
Raspbian_root
Raspbian_-_Boot_to_Scratch_boot
Raspbian_-_Boot_to_Scratch_root
RaspBMC_boot
RaspBMC_root
</pre>

If a file is found with the appropriate base filename above and one of the following extensions, then the following actions are carried out:
A filename ending in `.tar` is untarred onto the appropriate partition.
A filename ending in `.tar.xz` is decompressed, and untarred onto the appropriate partition.

So to add/replace some custom files on your distro, you just need to create a tar ball with the correct name, optionally compress it using XZ, drop it into the distro folder and install the distro as usual - simples! Some helper scripts are provided to help create these tarballs (see the Helpers folder).

(A filename with the appropriate basename ending in `.txt` is processed according to the Advanced Customisation section described below.)

If you add any other distros, flavours or OS partition names, you need to name the custom files according to the filename format above and add the following line to the partition_setup.sh script for that distro:
        `if [ -e /mnt/customise.sh ]; then . /mnt/customise.sh; fi`
This technique can also be used on the data partition - just create a partition_setup.sh file containing just this line. However, it is not really necessary as you could more easily just replace the original data.tar.xz file with your own, since it only contains a README.txt file.

### How to Create a Custom Tarball

These instructions assume you already have a working installation of a distro on the RPi and you want to capture the customisations you have made for future installations of the same distro.

1. Firstly you need to start from a working installation of the distro. I suggest you use NOOBS to install the distro first.
2. Modify any existing, or create any new files that you want to be included in your customisation.
3. For manageability I suggest creating a simple text file that contains a list of all the new/modified files that you want, with one fullpathname on each line.
For example:

```$>sudo nano files.txt<br>
/etc/network/interfaces
/etc/init.d/rc.local```

4. Now create the tar ball using this text file as input, as follows:

```$>sudo tar cvf &lt;flavour&gt;_&lt;partitionName&gt;.tar -T files.txt
$>sudo xz &lt;flavour&gt;_&lt;partitionName&gt;.tar
```

(See the Helpers folder for alternative ways to do this using scripts).
5. Copy the tarball to the appropriate OS folder.

### Advanced Customisation
Sometimes, you may want to have greater control over your customisations. Maybe you want to:
* segregate them into separate tar files for distinct uses.
* give them better names according to their use.
* have easier control over which ones should be installed.
* share files between different flavours of the same distro.
* provide raw files that are not tarred or compressed, e.g. by direct copying on to the recovery partition using Windows.
For these and other uses, the (flavour)_(partitionName).txt file can be useful.

This text file contains a list of files (one per line) to be installed to the distro AFTER the above `.tar` or `.tar.xz` files have been installed.  In this way some tweaks can be applied to existing .tar files without having to modify/rebuild them.

The text file is processed a line at a time to extract the filenames to be processed.
Any filename ending in `.tar` is untarred to the root of the partition.
Any filename ending in `.tar.xz` is decompressed and then untarred to the root of the partition.
Any other filename is copied directly to the partition.

NOTE: If you are already using a `(flavour)_(partitionName).tar(.xz)` file, you should NOT specify it in this text file as well, otherwise it would be installed twice.

If you are directly copying files, you may need to provide additional information in the form of optional fields on the same line.

There are five fields as follows (separated by spaces):

	Filename destination attributes user group

Only the filename field is mandatory and it is the only field used for TAR and XZ files; the others can be omitted and default values will then be applied. If you want to omit a field but follow it with another field, then use a '#' instead to keep the relative placement of the fields.

Blank lines will be ignored.
Comments can be added by starting the line with a '#' in the first column, or adding the comment after field 5.

Here are some examples to illustrate this:
* Readme.txt
* Readme.txt # 0644
* nc-helpers.tar
* wifi/interfaces /etc/network 0644 root root
* wifi/wpa_supplicant.conf /etc/wpa_supplicant 0600 root root

(The last 2 examples above show how using this direct copy technique, it is possible to specify the '/etc/network/interfaces' and '/etc/wpa_supplicant/wpa_supplicant.conf' files for easy wifi setup from Windows, whilst specifying the correct attributes and avoiding the problem of creating Tar files from Windows.)

#### Filename
This is the name of the file you want to copy from the recovery partition.
It can be stored in the /os/distro folder, or any subfolder. If you put it in a subfolder then this must be specified.
e.g. 
To copy the file `/os/Raspbian/readme.txt`, use `readme.txt`
To copy the file `/os/Raspbian/folder/readme.txt`, use `folder/readme.txt`
The folder name is only used to locate the source file. It is not used as part of the destination folder.
This field is mandatory.

If you need to include a filename that has embedded spaces in it, then you must enclose it in double quotation marks:
e.g.
* "my wifi/interfaces" /etc/network 0644 root root

#### Destination
This is the name of the destination folder where the file is to be stored on the target partition, relative to the root. E.g. `/home/pi`. It must begin with a slash, but have no trailing slash.
This field is optional. If not specified, then the root directory is used.
If you need to include a destination pathname that includes embedded spaces,then enclose this in double quotations.

#### Attributes
This specifies the attributes to be applied to the new file using the chmod command. e.g. `0644`. I guess options such as `+x` would also work but I've not tried.

#### User
This specifies the new user of the file e.g. `pi` or `root` etc.

#### Group
This specifies the new group of the file e.g. `root`

### Selecting a Method of customisation###
It can be confusing to decide which type of customisation to use, so here is a short guide.
* TAR files are very convenient when there are many related files to be installed, possibly in different folders, and where file permissions or ownership are important. They capture the contents, ownership and permissions of each file into a single TAR file which is then easily managed. So they are best created directly on an existing distro on the RPi. Not so many compression programs allow you to create a TAR file on Windows (7-zip can), but nevertheless, the file permissions and attributes cannot be set. Plain TAR files are not compressed and append 2 blocks of 512 bytes at the end. So the minimum size of a TAR file is 10kB. This can be quite an overhead if you only want to install a couple of small script files.
* TAR.XZ files are TAR files that have been compressed using the XZ program. They therefore retain the advantages of the TAR file's manageability, but also avoid the TAR file's largish size. It is best to compress them on the RPi, but it can be done on another Linux distro, but not so easily on Windows.
* If you want to create your customisation on Windows, referencing files from the TXT file may be the easiest method. This does not provide any compression, nor does it collect the separate files into one single file for manageability. However, it does provide control of user permissions and ownership. This is also a convenient method if you only want to install 1 or 2 small files. If you are creating script files on Windows, be careful to choose Linux line endings. Some editing programs, like Notepad++ allow you to visualise the line endings and change them from Windows to Linux and vice versa.

## Testing & Retrospective customisation

Since noobsconfig executes after NOOBS has installed a distro, it can be a lengthy process to test any customisations as they are developed, because each test potentially means installing a distro and waiting to see the result. Also, if you already have a Raspbian distro installed by noobs, then you probably don't want to have to overwrite it all just to test your scripts. Or maybe you have created a new 'flavour' to install your customisations and you want to install them onto your existing distro that was installed as another flavour.

There is a script called `retro.sh` that is placed on the root of the recovery partition to aid testing, or to apply a customisation retrospectively, i.e. after a distro has already been installed by NOOBS.

The purpose of `retro.sh` is to apply a set of customisations from the recovery partition to the currently installed distro, after that distro has been installed and is now executing. It works on a partition at a time, so if your distro has 2 partitions that you want to customise, you need to run it once for each partition. It requires a bit of work to setup the environment first, and a few arguments to tell it what it does, but these are easily captured into a script.

The main thing that needs to be done is to mount the recovery partition so that it is accessible. Also note that the installation has to be done by the root user (or using sudo) since it may need to (over)write system files.

### retro.sh
Usage: sudo ./retro.sh [source folder] [destination folder] [(flavour)_(partitionName)]
Example1: sudo ./retro.sh /mnt/os/Raspbian / Raspbian_root
Example2: sudo ./retro.sh /mnt/os/Raspbian /boot/ Raspbian_boot

### Example use of retro.sh
Here is an example script file that automates the retrospective installation or testing of a Raspbian customisation.

    #!/bin/sh
    # Make sure only root can run our script
    if [ "$(id -u)" != "0" ]; then
       echo "This script must be run as root" 1>&2
       exit 1
    fi
    
    #Mount the recovery partition
    mount /dev/mmcblk0p1 /mnt
    cdir=`pwd`
    cd /mnt
    #Install the customisations
    ./retro.sh /mnt/os/Raspbian /boot/ RaspbianMyFlavour_boot
    ./retro.sh /mnt/os/Raspbian / RaspbianMyFlavour_root
    #Restore 
    cd $cdir
    sync
    sleep 1
    umount /mnt
    echo "Customisation done."

## Further Examples
You will find some examples of how to apply some configurations to Raspbian in the Examples/Raspbian folder.
Please see zeroconf_wifi.md for a very quick setup of a WPA/WPA2 wifi network.
I welcome other examples, particularly for the other Linux distros.
