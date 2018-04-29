#!/bin/bash


export SDK_PATH="`xcrun --sdk iphoneos --show-sdk-path`"
export CC="`xcrun -f clang`"
export CFLAGS="-isysroot $SDK_PATH -miphoneos-version-min=9.0 -arch arm64" 
export LDFLAGS="-isysroot $SDK_PATH -arch arm64" 
export CONFIG_FLAGS="--with-zlib --with-modules --with-valid --with-tree --with-xpath --with-xptr --with-modules --with-reader --with-regexps --with-schemas --with-html --with-iconv --with-threads"
export PWD=`pwd`
export BUILD_DIR="${PWD}/build"

mkdir -p build/arm64
mkdir -p build/armv7s
mkdir -p build/i386
mkdir -p build/x86_64

# make for ARM64

say "building for arm64"

./autogen.sh --host=aarch64-apple-darwin $CONFIG_FLAGS
make DESTDIR="${BUILD_DIR}"/arm64/ install

# make for armv7s

say "building for armv7s"

unset CFLAGS LDFLAGS
export CFLAGS="-isysroot $SDK_PATH -miphoneos-version-min=9.0 -arch armv7s" 
export LDFLAGS="-isysroot $SDK_PATH -arch armv7s" 

make distclean

./autogen.sh --host=arm-apple-darwin7s $CONFIG_FLAGS
make DESTDIR="${BUILD_DIR}"/armv7s/ install

make distclean

#make for i386 simulator

unset CFLAGS LDFLAGS SDK_PATH

export SDK_PATH="`xcrun --sdk iphonesimulator --show-sdk-path`"
export CFLAGS="-isysroot $SDK_PATH -miphoneos-version-min=9.0 -arch i386" 
export LDFLAGS="-isysroot $SDK_PATH -arch i386"

say "building for i386"

./autogen.sh --host=i386-apple-darwin $CONFIG_FLAGS
make DESTDIR="${BUILD_DIR}"/i386/ install

#make for x86_64 simulator

unset CFLAGS LDFLAGS

CFLAGS="-isysroot $SDK_PATH -miphoneos-version-min=9.0 -arch x86_64" 
LDFLAGS="-isysroot $SDK_PATH -arch x86_64"

say "building for x86_64"

./autogen.sh --host=i386-apple-darwin $CONFIG_FLAGS
make DESTDIR="${BUILD_DIR}"/x86_64/ install

# lipo together

cd build
lipo -create arm64/usr/local/lib/libxml2.a i386/usr/local/lib/libxml2.a armv7s/usr/local/lib/libxml2.a x86_64/usr/local/lib/libxml2.a -output libxml2.a

# done

echo "DONE !"
say "Done"