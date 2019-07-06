#!/bin/sh

export USER_DIR=${USER_DIR:="/usbdrive"}
# PATCH_DIR=${PATCH_DIR:="/usbdrive/Patches"}
# FW_DIR=${FW_DIR:="/root"}
# SCRIPTS_DIR=$FW_DIR/scripts

# should be run from motherhost package installer
grep -q 'ID=archarm' /etc/os-release; 
if [ ! $? -eq 0 ] 
then 
   oscsend localhost 4001 /oled/aux/line/1 s "only valid for"
   oscsend localhost 4001 /oled/aux/line/2 s "organelle-1"
   cd ..
   rm -rf $1
   exit 128
fi

~/scripts/remount-rw.sh

echo installing sc > $USER_DIR/sc_install.log

oscsend localhost 4001 /oled/aux/line/2 s "dependent pkgs"
pacman -U --noconfirm pkgs/readline-7.0.003-1-armv7h.pkg.tar.xz  2>&1 >> $USER_DIR/sc_install.log 
ln -s /usr/lib/libreadline.so.7.0 /usr/lib/libreadline.so.6  2>&1 >> $USER_DIR/sc_install.log 

oscsend localhost 4001 /oled/aux/line/2 s "install sc"
unzip -o sc/sc.zip  -d /usr/local  2>&1 >> $USER_DIR/sc_install.log 


echo install done  >>$USER_DIR/sc_install.log

cd ..
rm -rf $1

exit 1
