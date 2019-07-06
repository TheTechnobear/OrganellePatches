#!/bin/sh

grep -q 'ID=archarm' /etc/os-release; 
if [ ! $? -eq 0 ] 
then 
   oscsend localhost 4001 /oled/aux/line/1 s "only valid for"
   oscsend localhost 4001 /oled/aux/line/2 s "organelle-1"
   cd ..
   rm -rf $1
   exit 128
fi


USER_DIR=${USER_DIR:="/usbdrive"}
PATCH_DIR=${PATCH_DIR:="/usbdrive/Patches"}
export FW_DIR=${FW_DIR:="/root"}
# SCRIPTS_DIR=$FW_DIR/scripts


oscsend localhost 4001 /oled/setscreen i 1

oscsend localhost 4001 /oled/gClear ii 1 1
oscsend localhost 4001 /oled/gPrintln iiiiis  1 2 0 8 1 "Resize SDCard"
oscsend localhost 4001 /oled/gFlip i 1

oscsend localhost 4001 /oled/setscreen i 1


~/scripts/remount-rw.sh
if [ -f "stage2" ]
then 
oscsend localhost 4001 /oled/aux/line/1 s "Resizing"
oscsend localhost 4001 /oled/aux/line/2 s "Partition..."
resize2fs /dev/mmcblk0p2
sleep 2
rm stage2
oscsend localhost 4001 /oled/aux/line/1 s "Done !!!"
oscsend localhost 4001 /oled/aux/line/2 s "Enjoy"
else 
oscsend localhost 4001 /oled/aux/line/1 s "Note: This is done"
oscsend localhost 4001 /oled/aux/line/2 s "two in stages!"
oscsend localhost 4001 /oled/aux/line/3 s "this is part one"
sleep 5
oscsend localhost 4001 /oled/aux/line/3 s " "
oscsend localhost 4001 /oled/aux/line/1 s "Recreating"
oscsend localhost 4001 /oled/aux/line/2 s "Partition..."
fdisk /dev/mmcblk0 << END
d
2
n
p



w
q
END
touch stage2
sleep 2
oscsend localhost 4001 /oled/aux/line/1 s "Now reboot, then"
oscsend localhost 4001 /oled/aux/line/2 s "run this again!"
sleep 2
fi
