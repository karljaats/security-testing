#!/bin/bash

CXXFLAGS='-std=c++11' make target

#sudo apt-get install python2.7
#sudo ln -s /usr/bin/python /bin/python2.7

python --version
python2 --version
python3 --version

sudo apt-get update
sudo apt-get install make autoheader autoconf automake libtool curl make g++ gcc unzip pkg-config doxygen

./autogen.sh --without-cython
make CXXFLAGS='-std=c++14'
sudo make install
sudo ldconfig # refresh shared library cache.