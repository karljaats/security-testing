#!/bin/bash

sudo apt-get update
sudo apt-get install autoconf automake libtool curl make g++ unzip
sudo apt-get install libssl-dev


./buildconf
./configure --without-openssl --without-libz
make