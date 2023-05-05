#!/bin/bash

export BINUTILS_VERSION=2.40
export GCC_VERSION=13.1.0

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

wget https://ftp.gnu.org/gnu/binutils/binutils-$BINUTILS_VERSION.tar.xz
wget https://ftp.gnu.org/gnu/gcc/gcc-$GCC_VERSION/gcc-$GCC_VERSION.tar.xz

echo +++++++++++++++++++++++++++
echo PART III
echo Expanding sources
echo +++++++++++++++++++++++++++

unxz binutils-$BINUTILS_VERSION.tar.xz
unxz gcc-$GCC_VERSION.tar.xz

tar -xvf binutils-$BINUTILS_VERSION.tar
tar -xvf gcc-$GCC_VERSION.tar

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
../binutils-$BINUTILS_VERSION/configure --target=$TARGET --prefix="$PREFIX" --with-sysroot --disable-nls --disable-werror
make -j$(nproc)
make install

echo +++++++++++++++++++++++++++
echo PART VI
echo Building gcc
echo +++++++++++++++++++++++++++

cd ..

mkdir build-gcc
cd build-gcc
../gcc-$GCC_VERSION/configure --target=$TARGET --prefix="$PREFIX" --disable-nls --enable-languages=c,c++ --without-headers
make all-gcc -j$(nproc)
make all-target-libgcc -j$(nproc)
make install-gcc
make install-target-libgcc
