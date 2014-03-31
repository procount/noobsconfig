#!/bin/sh
#PWD=/mnt2 = root of 1st FAT partition of OS.

set -ex

if [ -e /mnt/customise.sh ]; then /mnt/customise.sh; fi

