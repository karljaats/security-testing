#!/bin/bash

CXXFLAGS='-std=c++11' make target

sudo apt-get update
sudo apt-get install make autoheader autoconf automake libtool curl make g++ gcc unzip pkg-config doxygen scons git bazel
sudo apt-get install protobuf-compiler python-protobuf
pip install --upgrade protobuf grpcio-tools

#bazel build
chmod +rwx examples
chmod +rwx examples/simple
chmod +rwx examples/simple/Makefile
chmod +rwx generator
chmod +rwx generator/protoc

cd ./generator/proto
make
make install

cd ..
cd ..
cd ./examples/simple
make

#cd ./examples/cmake_simple
#protoc --plugin=protoc-gen-nanopb=nanopb/generator/protoc-gen-nanopb --nanopb_out=. myprotocol.proto
#cmake .
#make