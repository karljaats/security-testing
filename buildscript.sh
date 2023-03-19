#!/bin/bash

CXXFLAGS='-std=c++11' make target

sudo apt-get update
sudo apt-get install python
sudo apt-get install make autoheader autoconf automake libtool curl make g++ gcc unzip pkg-config doxygen

./autogen.sh
make CXXFLAGS='-std=c++14'
sudo make install
sudo ldconfig # refresh shared library cache.