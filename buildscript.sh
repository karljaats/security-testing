#!/bin/bash

sudo apt-get update
sudo apt-get install autoconf automake libtool curl make g++ unzip
sudo apt install libssl-dev


./buildconf
./configure
make