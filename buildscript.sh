#!/bin/bash

CXXFLAGS='-std=c++11' make target

sudo apt-get update
sudo apt-get install -y --allow-downgrades openssl=1.1.0i

openssl version
apt list openssl

./autogen.sh

./configure
#make
make CXXFLAGS='-std=c++11'
sudo make install
#sudo ldconfig # refresh shared library cache.
