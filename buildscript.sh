#!/bin/bash

CXXFLAGS='-std=c++11' make target

sudo apt-get update
openssl_ver=`sudo apt-cache madison openssl | grep xenial-updates | awk '{print $3}'`
libssl_ver=`sudo apt-cache madison libssl-dev | grep xenial-updates | awk '{print $3}'`
[ -n "${openssl_ver}" ] && [ -n "${libssl_ver}" ] && \
sudo apt-get install -y --allow-downgrades openssl=${openssl_ver} libssl-dev=${libssl_ver}

openssl version
apt list openssl

./autogen.sh

./configure
#make
make CXXFLAGS='-std=c++11'
sudo make install
#sudo ldconfig # refresh shared library cache.
