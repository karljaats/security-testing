#!/bin/bash

sudo apt-get update
sudo apt-get install autoconf automake libtool curl make g++ gcc unzip libboost-all-dev
sudo apt-get install \
    cmake \
    libboost-all-dev \
    libevent-dev \
    libdouble-conversion-dev \
    libgoogle-glog-dev \
    libgflags-dev \
    libiberty-dev \
    liblz4-dev \
    liblzma-dev \
    libsnappy-dev \
    zlib1g-dev \
    binutils-dev \
    libjemalloc-dev \
    libssl-dev \
    pkg-config \
	libunwind8-dev \
    libelf-dev \
    libdwarf-dev
	
sudo ./build/fbcode_builder/getdeps.py install-system-deps --recursive
	
wget https://github.com/google/googletest/archive/release-1.8.0.tar.gz && \
tar zxf release-1.8.0.tar.gz && \
rm -f release-1.8.0.tar.gz && \
cd googletest-release-1.8.0 && \
cmake . && \
make && \
make install

cd ..

CXXFLAGS='-std=c++14' make target

cmake . 
make -j $(nproc) CXXFLAGS='-std=c++14'