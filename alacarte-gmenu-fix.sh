#!/bin/bash
# Small script to fix Alacarte on Fedora 16 (32-bit)
# Run this script as su -
# Version 0.1
# May 11, 2012
# Copyright (c) 2012 Blake McCulley <http://enile8.org>
# https://github.com/enile8/fedora-shell-scripts
# This script is licensed under GNU GPL version 2.0 or above
#==========================================================================
# Move to tmp directory, create a new directory named copy and move into that
cd /tmp
mkdir copy
cd ./copy
sleep 1
# Download the Fedora 15 rpm and explode it
rpm2cpio http://archive.fedoraproject.org/pub/fedora/linux/releases/15/Fedora/i386/os/Packages/gnome-menus-3.0.1-1.fc15.i686.rpm | cpio -ivd
# Copy the necessary files
cp /tmp/copy/usr/lib/libgnome-menu.so.2* /usr/lib
cp /tmp/copy/usr/lib/python2.7/site-packages/gmenu.so /usr/lib/python2.7/site-packages
# Move to the usr/lib directory to create the necessary symbolic link
cd /usr/lib
ln -s /usr/lib/libgnome-menu.so.2.4.13 libgnome-menu.so.2
# Move back to the tmp directory and remove the copy folder that was created earlier
cd /tmp
rm -R copy
