#!/bin/bash

sudo apt-get update
sudo apt-get install autoconf automake libtool curl make g++ unzip

./autogen.sh

./configure
make
sudo make install
sudo ldconfig # refresh shared library cache.
