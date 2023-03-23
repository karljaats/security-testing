#!/bin/bash

CXXFLAGS='-std=c++11' make target

sudo apt-get update
sudo apt-get install autoconf automake libtool curl make g++ unzip libc-ares-dev libwebsockets-dev libssl-dev xsltproc docbook-xsl uthash utlist cJSON

./autogen.sh

./configure
make CXXFLAGS='-std=c++14'
sudo make install
sudo ldconfig # refresh shared library cache.
