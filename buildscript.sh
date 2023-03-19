#!/bin/bash

sudo apt-get update
sudo apt-get install make autoheader autoconf automake libtool curl make g++ gcc unzip pkg-config doxygen scons git bazel
sudo apt-get install protobuf-compiler python3-protobuf
sudo apt-get install libprotoc-dev
pip install --upgrade protobuf grpcio-tools
pip install --ignore-installed six
sudo pip install protobuf

#PROTOC_ZIP=protoc-3.14.0-linux-x86_64.zip
#curl -OL https://github.com/protocolbuffers/protobuf/releases/download/v3.14.0/$PROTOC_ZIP
#sudo unzip -o $PROTOC_ZIP -d /usr/local bin/protoc
#sudo unzip -o $PROTOC_ZIP -d /usr/local 'include/*'
#rm -f $PROTOC_ZIP

chmod +rwx generator-bin
chmod +rwx generator-bin/protoc
chmod +rwx generator-bin/protoc.bin
chmod +rwx examples
chmod +rwx examples/simple
chmod +rwx examples/simple/Makefile
chmod +rwx generator
chmod +rwx generator/protoc
chmod +rwx generator/protoc.bat
chmod +rwx generator/protoc-gen-nanopb
chmod +rwx generator/protoc-gen-nanopb.bat

#protoc --plugin=protoc-gen-nanopb=generator/protoc-gen-nanopb --nanopb_out=. myprotocol.proto

#protoc --version

#cd ./generator/proto
#make
#make install
#cd ..
#cd ..


generator-bin/protoc --plugin=protoc-gen-nanopb=generator/protoc-gen-nanopb --nanopb_out=. simple.proto

make

#cd ./examples/cmake_simple
#protoc --plugin=protoc-gen-nanopb=nanopb/generator/protoc-gen-nanopb --nanopb_out=. myprotocol.proto
#cmake .
#make