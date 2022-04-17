#!/bin/bash

echo +++++++++++++++++++++++++++
echo PART I
echo Installing dependencies
echo +++++++++++++++++++++++++++

sudo apt install libbison-dev flex libgmp-dev libmpfr-dev libmpc-dev texinfo gcc g++ make

echo +++++++++++++++++++++++++++
echo PART II
echo Downloading sources
echo +++++++++++++++++++++++++++

cd /tmp/

wget https://ftp.gnu.org/gnu/binutils/binutils-2.37.tar.xz
wget https://ftp.gnu.org/gnu/gcc/gcc-11.2.0/gcc-11.2.0.tar.xz

echo +++++++++++++++++++++++++++
echo PART III
echo Expanding sources
echo +++++++++++++++++++++++++++

unxz binutils-2.37.tar.xz
unxz gcc-11.2.0.tar.xz

tar -xvf binutils-2.37.tar
tar -xvf gcc-11.2.0.tar

echo +++++++++++++++++++++++++++
echo PART IV
echo Preparing enviroment vars
echo +++++++++++++++++++++++++++

mkdir $HOME/cross_compiler

export PREFIX="$HOME/cross_compiler"
export TARGET=x86_64-elf
export PATH="$PREFIX/bin:$PATH"


echo +++++++++++++++++++++++++++
echo PART V
echo Building binutils
echo +++++++++++++++++++++++++++

mkdir build-binutils
cd build-binutils
../binutils-2.37/configure --target=$TARGET --prefix="$PREFIX" --with-sysroot --disable-nls --disable-werror
make
make install

echo +++++++++++++++++++++++++++
echo PART VI
echo Building gcc
echo +++++++++++++++++++++++++++

cd ..

mkdir build-gcc
cd build-gcc
../gcc-11.2.0/configure --target=$TARGET --prefix="$PREFIX" --disable-nls --enable-languages=c,c++ --without-headers
make all-gcc
make all-target-libgcc
make install-gcc
make install-target-libgcc
