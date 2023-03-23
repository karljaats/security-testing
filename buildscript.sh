#!/bin/bash

sudo apt-get update
sudo apt-get install autoconf automake libtool curl make g++ unzip
sudo apt-get install libctemplate-dev libicu-dev libsasl2-dev libtidy-dev uuid-dev libxml2-dev libglib2.0-dev autoconf automake libtool

pwd

mkdir ~/libetpan
cd ~/libetpan
git clone --depth=1 https://github.com/dinhviethoa/libetpan
cd libetpan
./autogen.sh
make >/dev/null
sudo make install prefix=/usr >/dev/null

cd /home/runner/work/security-testing/security-testing
cmake .
make