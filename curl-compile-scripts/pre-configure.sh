#!/bin/bash
TARGET=android-8

PWD="$(pwd)"

if [ -z "$NDK_ROOT" ]; then
  echo "Please set your NDK_ROOT environment variable first"
  exit 1
fi

REL_SCRIPT_PATH="$(dirname $0)"
SCRIPTPATH=$(realpath $REL_SCRIPT_PATH)
CURLPATH="$SCRIPTPATH/../curl"

cd $CURLPATH

if [ ! -x "$CURLPATH/configure" ]; then
	echo "Curl needs external tools to be compiled"
	echo "Make sure you have autoconf, automake and libtool installed"

	./buildconf

	EXITCODE=$?
	if [ $EXITCODE -ne 0 ]; then
		echo "Error running the buildconf program"
		cd $PWD
		exit $EXITCODE
	fi
else
	echo "Omitting buildconf"
fi

GCC_PATH=$($NDK_ROOT/ndk-which gcc)

export SYSROOT="$NDK_ROOT/platforms/$TARGET/arch-arm"
export CPPFLAGS="-I$NDK_ROOT/platforms/$TARGET/arch-arm/usr/include --sysroot=$SYSROOT"

export CC=$($NDK_ROOT/ndk-which gcc)
export LD=$($NDK_ROOT/ndk-which ld)
export CPP=$($NDK_ROOT/ndk-which cpp)
export CXX=$($NDK_ROOT/ndk-which g++)
export AS=$($NDK_ROOT/ndk-which as)
export AR=$($NDK_ROOT/ndk-which ar)
export RANLIB=$($NDK_ROOT/ndk-which ranlib)

./configure --host=arm-linux-androideabi --target=arm-linux-androideabi \
            --without-ssl \
            --enable-static \
            --disable-shared \
            --disable-verbose \
            --enable-threaded-resolver \
            --enable-libgcc \
            --enable-ipv6 \
            --disable-ares \
            --disable-ftp \
            --disable-file \
            --disable-gopher \
            --disable-ldap \
            --disable-ldaps \
            --disable-rtsp \
            --disable-proxy \
            --disable-dict \
            --disable-telnet \
            --disable-tftp \
            --disable-pop3 \
            --disable-imap \
            --disable-smtp \
            --disable-manual \
            --disable-libcurl-option \
            --disable-sspi \
            --disable-ntlm-wb \
            --disable-soname-bump \
            --with-random \
            --without-zlib

EXITCODE=$?
if [ $EXITCODE -ne 0 ]; then
  echo "Error running the configure program"
  cd $PWD
  exit $EXITCODE
fi

cd $PWD
