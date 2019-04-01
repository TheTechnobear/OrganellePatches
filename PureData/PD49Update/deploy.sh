#!/bin/sh

export USER_DIR=${USER_DIR:="/usbdrive"}
# PATCH_DIR=${PATCH_DIR:="/usbdrive/Patches"}
# FW_DIR=${FW_DIR:="/root"}
# SCRIPTS_DIR=$FW_DIR/scripts

# should be run from motherhost package installer
~/scripts/remount-rw.sh

echo installing pd49 > $USER_DIR/install.log

oscsend localhost 4001 /oled/aux/line/2 s "PureData 0.49"
pacman -U --noconfirm pkgs/*  2>&1 >> $USER_DIR/install.log 

echo install done  >>$USER_DIR/install.log

cd ..
rm -rf $1

exit 1
