#!/bin/bash

sudo apt-get update
sudo apt-get install autoconf automake libtool curl make g++ gcc unzip libplist-dev=2.0.0-2ubuntu1 usbmuxd pkg-config inotify-tools libplist++-dev

./autogen.sh
make
