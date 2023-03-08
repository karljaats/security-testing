#!/bin/bash

CXXFLAGS='-std=c++17' make target

sudo apt-get update
sudo apt-get install autoconf automake libtool curl make g++ unzip libssl-dev

./autogen.sh

./configure
#make
make CXXFLAGS='-std=c++17'
sudo make install
#sudo ldconfig # refresh shared library cache.
