#!/bin/sh

export USER_DIR=${USER_DIR:="/usbdrive"}
# PATCH_DIR=${PATCH_DIR:="/usbdrive/Patches"}
# FW_DIR=${FW_DIR:="/root"}
# SCRIPTS_DIR=$FW_DIR/scripts
SYSTEM_DIR=$USER_DIR/System

echo installing vnc > $USER_DIR/install.log

grep -q 'ID=archarm' /etc/os-release; 
if [ ! $? -eq 0 ] 
then 
	echo platform organelle-m  2>&1 >> $USER_DIR/install.log
	sudo ~/fw_dir/scripts/remount-rw.sh 2>&1 >> $USER_DIR/install.log
	oscsend localhost 4001 /oled/aux/line/2 s "configure"
	cp vnc.m/* /home/music/.vnc 2>&1 >> $USER_DIR/install.log
	sync
	sudo ~/fw_dir/scripts/remount-ro.sh
else 
	echo platform organelle-1  2>&1 >> $USER_DIR/install.log
	~/scripts/remount-rw.sh
	oscsend localhost 4001 /oled/aux/line/2 s "install pkgs"
	pacman -U --needed --noconfirm pkgs.1/*  2>&1 >> $USER_DIR/install.log 
	oscsend localhost 4001 /oled/aux/line/2 s "configure"
	rm -rf /root/.vnc
	mv vnc.1 /root/.vnc
	chmod 600 /root/.vnc/passwd
	sync
	~/scripts/remount-ro.sh
fi



rm -rf ${SYSTEM_DIR}/TigerVNC  ${SYSTEM_DIR}/StartVNC
mkdir ${SYSTEM_DIR}
mv StartVNC ${SYSTEM_DIR}/StartVNC


oscsend localhost 4001 /oled/aux/line/2 s "done"

echo install done  >>$USER_DIR/install.log

cd ..
rm -rf $1

exit 1
