#!/bin/sh

export USER_DIR=${USER_DIR:="/usbdrive"}
# PATCH_DIR=${PATCH_DIR:="/usbdrive/Patches"}
# FW_DIR=${FW_DIR:="/root"}
# SCRIPTS_DIR=$FW_DIR/scripts
SYSTEM_DIR=$USER_DIR/System


grep -q 'ID=archarm' /etc/os-release; 
if [ ! $? -eq 0 ] 
then 
   oscsend localhost 4001 /oled/aux/line/1 s "only valid for"
   oscsend localhost 4001 /oled/aux/line/2 s "organelle-1"
   exit -1
fi


# should be run from motherhost package installer
~/scripts/remount-rw.sh

echo installing tigervnc > $USER_DIR/install.log

oscsend localhost 4001 /oled/aux/line/2 s "install pkgs"
pacman -U --needed --noconfirm pkgs/*  2>&1 >> $USER_DIR/install.log 
oscsend localhost 4001 /oled/aux/line/2 s "configure"
rm -rf /root/.vnc
mv vnc /root/.vnc
rm -rf ${SYSTEM_DIR}/TigerVNC
mkdir ${SYSTEM_DIR}
mv TigerVNC ${SYSTEM_DIR}/TigerVNC
oscsend localhost 4001 /oled/aux/line/2 s "done"

echo install done  >>$USER_DIR/install.log

cd ..
rm -rf $1

exit 1
