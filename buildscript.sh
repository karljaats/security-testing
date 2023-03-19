#!/bin/bash

CXXFLAGS='-std=c++11' make target

sudo apt-get update
sudo apt-get install make autoheader autoconf automake libtool curl make g++ gcc unzip pkg-config doxygen scons git bazel
sudo apt-get install protobuf-compiler python-protobuf
pip install --upgrade protobuf grpcio-tools

#bazel build

cd ./examples/simple

../../generator-bin/protoc --nanopb_out=. simple.proto
protoc --plugin=protoc-gen-nanopb=nanopb/generator/protoc-gen-nanopb --nanopb_out=. myprotocol.proto
make

#cd ./examples/cmake_simple
#protoc --plugin=protoc-gen-nanopb=nanopb/generator/protoc-gen-nanopb --nanopb_out=. myprotocol.proto
#cmake .
#make