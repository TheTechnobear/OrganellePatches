#!/bin/bash

USER_DIR=${USER_DIR:="/usbdrive"}
#PATCH_DIR=${PATCH_DIR:="${USER_DIR}/Patches"}
export FW_DIR=${FW_DIR:="/root"}
SCRIPTS_DIR=$FW_DIR/scripts
WORK_DIR=${WORK_DIR:="${USER_DIR}"}

cd $WORK_DIR

# clear aux screen
oscsend localhost 4001 /oled/aux/clear i 1
oscsend localhost 4001 /oled/setscreen i 1

oscsend localhost 4001 /oled/aux/line/2 s "running"
oscsend localhost 4001 /oled/aux/line/3 s "TigerVNC"

cp -R /root/.vnc /tmp
export HOME=/tmp

vncserver

