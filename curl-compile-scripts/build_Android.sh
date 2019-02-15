#!/bin/bash
TARGET=android-19

real_path() {
	[[ $1 = /* ]] && echo "$1" || echo "$PWD/${1#./}"
}

#Change this env variable to the number of processors you have
if [ -f /proc/cpuinfo ]; then
	JOBS=$(grep flags /proc/cpuinfo |wc -l)
elif [ ! -z $(which sysctl) ]; then
	JOBS=$(sysctl -n hw.ncpu)
else
	JOBS=2
fi

REL_SCRIPT_PATH="$(dirname $0)"
SCRIPTPATH=$(real_path $REL_SCRIPT_PATH)
CURLPATH="$SCRIPTPATH/../curl"
SSLPATH="$SCRIPTPATH/../openssl"

if [ -z "$NDK_ROOT" ]; then
	echo "Please set your NDK_ROOT environment variable first"
	exit 1
fi

if [[ "$NDK_ROOT" == .* ]]; then
	echo "Please set your NDK_ROOT to an absolute path"
	exit 1
fi

#Configure OpenSSL
cd $SSLPATH
./Configure android no-asm no-shared no-cast no-idea no-camellia no-whirpool
EXITCODE=$?
if [ $EXITCODE -ne 0 ]; then
	echo "Error running the ssl configure program"
	cd $PWD
	exit $EXITCODE
fi

#Build static libssl and libcrypto, required for cURL's configure
cd $SCRIPTPATH
$NDK_ROOT/ndk-build -j$JOBS -C $SCRIPTPATH ssl crypto
EXITCODE=$?
if [ $EXITCODE -ne 0 ]; then
	echo "Error building the libssl and libcrypto"
	cd $PWD
	exit $EXITCODE
fi

#Configure toolchain
TOOLCHAIN=$SCRIPTPATH/../toolchain
if [ -d "$TOOLCHAIN" ]; then
	echo Removing existing toolchain
	rm -rf "$TOOLCHAIN"
fi
$NDK_ROOT/build/tools/make-standalone-toolchain.sh --arch=arm --platform=$TARGET --install-dir=$TOOLCHAIN

# Setup cross-compile environment
export SYSROOT=$TOOLCHAIN/sysroot
export ARCH=armv7
export CC=$TOOLCHAIN/bin/arm-linux-androideabi-gcc
export CXX=$TOOLCHAIN/bin/arm-linux-androideabi-g++
export AR=$TOOLCHAIN/bin/arm-linux-androideabi-ar
export AS=$TOOLCHAIN/bin/arm-linux-androideabi-as
export LD=$TOOLCHAIN/bin/arm-linux-androideabi-ld
export RANLIB=$TOOLCHAIN/bin/arm-linux-androideabi-ranlib
export NM=$TOOLCHAIN/bin/arm-linux-androideabi-nm
export STRIP=$TOOLCHAIN/bin/arm-linux-androideabi-strip
export CHOST=$TOOLCHAIN/bin/arm-linux-androideabi

#Configure cURL
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
fi

export CFLAGS="--sysroot=$SYSROOT -march=$ARCH -mthumb"
export CPPFLAGS="$CFLAGS -I$TOOLCHAIN/include -DANDROID -DCURL_STATICLIB"
export LIBS="-lssl -lcrypto"
export LDFLAGS="-march=$ARCH -L$SCRIPTPATH/obj/local/armeabi-v7a"
./configure \
	--host=arm-linux-androideabi \
	--target=arm-linux-androideabi \
	--with-ssl=$SSLPATH \
	--enable-static \
	--disable-shared \
	--disable-verbose \
	--enable-threaded-resolver \
	--enable-libgcc \
	--enable-ipv6

EXITCODE=$?
if [ $EXITCODE -ne 0 ]; then
	echo "Error running the configure program"
	cd $PWD
	exit $EXITCODE
fi

#Build cURL
$NDK_ROOT/ndk-build -j$JOBS -C $SCRIPTPATH curl
EXITCODE=$?
if [ $EXITCODE -ne 0 ]; then
	echo "Error running the ndk-build program"
	exit $EXITCODE
fi

#Strip debug symbols and copy to the prebuilt folder
PLATFORMS=(arm64-v8a x86_64 armeabi-v7a x86)
DESTDIR=$SCRIPTPATH/../prebuilt-with-ssl/android

for p in ${PLATFORMS[*]}; do
  mkdir -p $DESTDIR/$p
  STRIP=$($SCRIPTPATH/ndk-which strip $p)

  SRC=$SCRIPTPATH/obj/local/$p/libcurl.a
  DEST=$DESTDIR/$p/libcurl.a

  if [ -z "$STRIP" ]; then
    echo "WARNING: Could not find 'strip' for $p"
    cp $SRC $DEST
  else
    $STRIP $SRC --strip-debug -o $DEST
  fi
done

#Copying cURL headers
if [ -d "$DESTDIR/include" ]; then
	echo "Cleaning headers"
	rm -rf "$DESTDIR/include"
fi
cp -R $CURLPATH/include $DESTDIR/
rm $DESTDIR/include/curl/.gitignore

cd $PWD
exit 0
