#!/bin/bash

sudo apt-get update
sudo apt-get install autoconf automake libtool curl make g++ gcc unzip libplist-dev usbmuxd pkg-config inotify-tools libplist++-dev

dpkg -L libplist-dev

./autogen.sh
make
