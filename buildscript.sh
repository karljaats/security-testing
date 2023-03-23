#!/bin/bash

sudo apt-get update
sudo apt-get install autoconf autoheader automake libtool curl make g++ gcc unzip libplist-dev usbmuxd pkg-config inotify

./autogen.sh
make
