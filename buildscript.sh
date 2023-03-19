#!/bin/bash

CXXFLAGS='-std=c++11' make target

sudo apt-get update
sudo apt-get install make autoheader autoconf automake libtool curl make g++ gcc unzip pkg-config doxygen scons git bazel
sudo apt-get install protobuf-compiler python-protobuf
sudo apt-get install libprotoc-dev
pip install --upgrade protobuf grpcio-tools

protoc --version

PROTOC_ZIP=protoc-3.14.0-linux-x86_64.zip
curl -OL https://github.com/protocolbuffers/protobuf/releases/download/v3.14.0/$PROTOC_ZIP
sudo unzip -o $PROTOC_ZIP -d /usr/local bin/protoc
sudo unzip -o $PROTOC_ZIP -d /usr/local 'include/*'
rm -f $PROTOC_ZIP

protoc --version

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