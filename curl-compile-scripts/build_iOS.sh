#!/bin/bash

realpath() {
    [[ $1 = /* ]] && echo "$1" || echo "$PWD/${1#./}"
}

XCODE="/Applications/Xcode.app/Contents/Developer"
if [ ! -d "$XCODE" ]; then
	echo "You have to install Xcode and the command line tools first"
	exit 1
fi

REL_SCRIPT_PATH="$(dirname $0)"
SCRIPTPATH=$(realpath "$REL_SCRIPT_PATH")
CURLPATH="$SCRIPTPATH/../curl"

PWD=$(pwd)
cd "$CURLPATH"

if [ ! -x "$CURLPATH/configure" ]; then
	echo "Curl needs external tools to be compiled"
	echo "Make sure you have autoconf, automake and libtool installed"

	./buildconf

	EXITCODE=$?
	if [ $EXITCODE -ne 0 ]; then
		echo "Error running the buildconf program"
		cd "$PWD"
		exit $EXITCODE
	fi
fi


export CC="$XCODE/Toolchains/XcodeDefault.xctoolchain/usr/bin/clang"
DESTDIR="$SCRIPTPATH/../prebuilt-with-ssl/iOS"

export IPHONEOS_DEPLOYMENT_TARGET="6"
ARCHS=(armv7 armv7s arm64 i386 x86_64)
HOSTS=(armv7 armv7s arm i386 x86_64)
PLATFORMS=(iPhoneOS iPhoneOS iPhoneOS iPhoneSimulator iPhoneSimulator)
SDK=(iPhoneOS iPhoneOS iPhoneOS iPhoneSimulator iPhoneSimulator)

#Build for all the architectures
for (( i=0; i<${#ARCHS[@]}; i++ )); do
	ARCH=${ARCHS[$i]}
	export CFLAGS="-arch $ARCH -pipe -Os -gdwarf-2 -isysroot $XCODE/Platforms/${PLATFORMS[$i]}.platform/Developer/SDKs/${SDK[$i]}.sdk -miphoneos-version-min=${IPHONEOS_DEPLOYMENT_TARGET} -fembed-bitcode"
	export LDFLAGS="-arch $ARCH -isysroot $XCODE/Platforms/${PLATFORMS[$i]}.platform/Developer/SDKs/${SDK[$i]}.sdk"
	if [ "${PLATFORMS[$i]}" = "iPhoneSimulator" ]; then
		export CPPFLAGS="-D__IPHONE_OS_VERSION_MIN_REQUIRED=${IPHONEOS_DEPLOYMENT_TARGET%%.*}0000"
	fi
	cd "$CURLPATH"
	./configure	--host="${HOSTS[$i]}-apple-darwin" \
			--with-darwinssl \
			--enable-static \
			--disable-shared \
			--enable-threaded-resolver \
			--disable-verbose \
			--enable-ipv6 
	EXITCODE=$?
	if [ $EXITCODE -ne 0 ]; then
		echo "Error running the cURL configure program"
		cd "$PWD"
		exit $EXITCODE
	fi

	make -j $(sysctl -n hw.logicalcpu_max)
	EXITCODE=$?
	if [ $EXITCODE -ne 0 ]; then
		echo "Error running the make program"
		cd $"PWD"
		exit $EXITCODE
	fi
	mkdir -p "$DESTDIR/$ARCH"
	cp "$CURLPATH/lib/.libs/libcurl.a" "$DESTDIR/$ARCH/"
	cp "$CURLPATH/lib/.libs/libcurl.a" "$DESTDIR/libcurl-$ARCH.a"
	make clean
done

#Build a single static lib with all the archs in it
cd "$DESTDIR"
lipo -create -output libcurl.a libcurl-*.a
rm libcurl-*.a

#Copying cURL headers
cp -R "$CURLPATH/include" "$DESTDIR/"
rm "$DESTDIR/include/curl/.gitignore"

#Patch headers for 64-bit archs
cd "$DESTDIR/include/curl"
sed 's/#define CURL_SIZEOF_LONG 8/\
#ifdef __LP64__\
#define CURL_SIZEOF_LONG 8\
#else\
#define CURL_SIZEOF_LONG 4\
#endif/'< curlbuild.h > curlbuild.h.temp

sed 's/#define CURL_SIZEOF_CURL_OFF_T 8/\
#ifdef __LP64__\
#define CURL_SIZEOF_CURL_OFF_T 8\
#else\
#define CURL_SIZEOF_CURL_OFF_T 4\
#endif/' < curlbuild.h.temp > curlbuild.h
rm curlbuild.h.temp

cd "$PWD"

