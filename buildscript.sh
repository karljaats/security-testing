#!/bin/bash

CXXFLAGS='-std=c++11' make target

sudo apt-get update
sudo apt-get install make autoheader autoconf automake libtool curl make g++ gcc unzip pkg-config doxygen scons git bazel

#bazel build

#cd ./examples/simple
#make

cd ./examples/cmake_simple
cmake .
make