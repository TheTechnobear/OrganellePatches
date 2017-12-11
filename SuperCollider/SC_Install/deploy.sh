#!/bin/sh

# should be run from motherhost package installer
~/scripts/remount-rw.sh

echo installing sc > $USER_DIR/sc_install.log

oscsend localhost 4001 /oled/aux/line/2 s "dependent pkgs"
pacman -U --noconfirm pkgs/readline-7.0.003-1-armv7h.pkg.tar.xz  2>&1 >> $USER_DIR/sc_install.log 
ln -s /usr/lib/libreadline.so.7.0 /usr/lib/libreadline.so.6  2>&1 >> $USER_DIR/sc_install.log 
pacman -U --noconfirm pkgs/unzip-6.0-12-armv7h.pkg.tar.xz  2>&1 >> $USER_DIR/sc_install.log 

oscsend localhost 4001 /oled/aux/line/2 s "install sc"
unzip -o sc/sc.zip  -d /usr/local  2>&1 >> $USER_DIR/sc_install.log 


echo install done  >>$USER_DIR/sc_install.log

cd ..
rm -rf $1

exit 1
