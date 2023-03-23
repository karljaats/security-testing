#!/bin/bash

sudo apt-get update
sudo apt-get install autoconf automake libtool curl make g++ unzip libavcodec-dev libavutil-dev libavformat-dev \
        libswresample-dev libavresample-dev \
        libsamplerate-dev libsndfile-dev \
        txt2man doxygen

make
