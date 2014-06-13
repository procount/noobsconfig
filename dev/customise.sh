#!/bin/sh

set -x

#Get the location of the OS images
imagefolder=`sed -n "s/.*\"imagefolder\".*:.*\"\(.*\)\".*/\1/p" <os_config.json`

#Get the OS flavour installed
flavour=`sed -n "s/.*\"flavour\".*:.*\"\(.*\)\".*/\1/p" <os_config.json |sed "s/ \+/_/g"`

#Get the list of partition names used
partLabels=`sed -n "s/.*\"label\".*:.*\"\(.*\)\".*/\1/p" <$imagefolder/partitions.json`

#Get the number of partitions used.
numparts=`echo $partLabels |wc -w`

process_file()
{
    local arg1=""
    local arg2=""
    local arg3=""
    local arg4=""
    local arg5=""

    #Complicated rubbish to process quoted spaced arguments to this function!
	local inquote=0 #State of inside/outside quotations
	local inarg=0   #State of within an argument
	local narg=0    #number of arguments processed
	local arg=""    #the current argument
    
    #Treat the arguments as one string and process each character.
    #inarg & inquote keep track of the state.
    for pos in `seq 1 ${#@}`
	do
		add=0;
		inc=0;
		c=`expr substr "$@" $pos 1`
		# echo "$c"
		case "$c" in
			"\"")
				inquote=`expr 1 - $inquote`
				if [ $inquote -eq 0 ]; then
					inc=1   #indicate end of an argument
                else
                    inarg=1; #indicate we have started an argument
				fi
				;;

			" ")
				if [ $inarg -eq 1 ]; then
					if [ $inquote -eq 0 ]; then
						inc=1   #indicate end of an argument
					else
						add=1   #add embedded space to argument
					fi
				fi
				;;
			*)
				inarg=1         #indicate we have started an argument 
				add=1           #add character to argument
				;;
		esac

		if [ $add -eq 1 ]; then
			arg="$arg$c"        #Append the current character
		fi

		if [ $inc -eq 1 ]; then
            #assign the current argument to the next variable
			narg=`expr $narg + 1`
			var="arg$narg"
			cmd="${var}=\"$arg\""
			eval "$cmd"
			inarg=0
			arg=""
		fi
	done
	if [ $inarg -eq 1 ]; then
            #last incomplete argument needs to be assigned to the next variable
			narg=`expr $narg + 1`
			var="arg$narg"
			cmd="${var}=\"$arg\""
			eval "$cmd"
			inarg=0
			arg=""
	fi
    ############

    #Here we just give the arguments meaningful names
    local tarfile="$arg1"
    local dstsubfolder="$arg2"
    local attributes="$arg3"
    local user="$arg4"
    local group="$arg5"

    if [ "$dstsubfolder" = "#" ]; then dstsubfolder=""; fi
    if [ "$attributes" = "#" ]; then attributes=""; fi
    if [ "$user" = '#' ]; then user=""; fi
    if [ "$group" = '#' ]; then group=""; fi

    if [ -e "$arg_srcfolder/$tarfile" ]; then
        #Copy custom file to the SD card partition root
        #cp $arg_srcfolder/$tarfile $arg_dstfolder
        #decompress & Untar the custom file
        #cd $arg_dstfolder
        ext=`echo $tarfile|awk -F . '{print $NF}'`
        case "$ext" in
            "xz" ) 
                xz -dc "$arg_srcfolder/$tarfile" | tar x -C "$arg_dstfolder"
                ;;
            "tar" ) 
                tar xvf "$arg_srcfolder/$tarfile" -C "$arg_dstfolder"
                ;;
            * )
                fname=`basename "$tarfile"`
                pathname=`dirname "$tarfile"`
                mkdir -p "$arg_dstfolder$dstsubfolder"
                cp "$arg_srcfolder/$tarfile" "$arg_dstfolder$dstsubfolder/$fname"
                if [ "$attributes" != "" ]; then chmod $attributes "$arg_dstfolder$dstsubfolder/$fname"; fi
                ug=""
                if [ "$user" != "" ]; then ug=$user; else ug=""; fi
                if [ "$group" != "" ]; then ug=$ug:$group; fi
                if [ "$ug" != "" ]; then chown $ug "$arg_dstfolder$dstsubfolder/$fname"; fi
                ;;
        esac
    fi
}

custom_part() 
{
    #parameters
    # $1 = srcfolder eg /mnt/os/xxxxx
    # $2 = Part dev eg /dev/mmcblk0p5
    # $3 = imagename eg Flavour_label
    local arg_srcfolder=$1
    local arg_imagename=$3
    local arg_dstfolder=/tmp/custom

    mkdir -p $arg_dstfolder
    mount $2 $arg_dstfolder

    #Look for a tar file
    tarfile=$arg_imagename.tar
    process_file "$tarfile"

    #Look for a tar.xz file
    tarfile=$tarfile.xz
    process_file "$tarfile"

    #Look for a txt file
    local txtfile=$arg_imagename.txt
    #Does the custom file exist?
    if [ -e $arg_srcfolder/$txtfile ]; then
        while read line
        do
            #remove trailing CR
            tarfile=`echo $line | tr -d '\r'`
            if [ ! -z "$tarfile" ]; then
                #remove lines starting with '#'
                tarfile=`echo $tarfile | sed '/^#/d'`
            fi
            if [ ! -z "$tarfile" ]; then
                #Only process non-blank lines
                process_file "$tarfile"
            fi
        done<$arg_srcfolder/$txtfile
    fi
    cd /mnt

    sync
    umount -f $arg_dstfolder
}

get_label()
{
    label=`echo $partLabels|cut -d' ' -f$1`
}

for p in `seq $numparts`
do
    #Get the partition name
    get_label $p
    #Create a custom file name from the flavour and partition names
    partLabel=$flavour"_"$label
    #Customise partition #p
    eval "t=\$part$p"
    custom_part "$imagefolder" "$t" "$partLabel"
done

cd /mnt
sync
