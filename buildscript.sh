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

cmake .
make -j $(nproc)