#!/bin/bash

CXXFLAGS='-std=c++11' make target

sudo apt-get update
sudo apt-get install openssl=1.1.1f-1ubuntu2.17

openssl version

./autogen.sh

./configure
#make
make CXXFLAGS='-std=c++11'
sudo make install
#sudo ldconfig # refresh shared library cache.
