curl-android-ios
================
The goal of this project is to provide a pre-compiled version of libcurl to be
used in Android and iOS.

It uses cURL from the upstream repository and it's updated frequently.

For Android, it also uses OpenSSL from its upstream repository.

If you want to build the library, scripts are provided for both platforms.
Test projects are also provided for both iOS and Android.

# How to compile
## Max OS X
```
brew install android-ndk
git clone https://github.com/gcesarmza/curl-android-ios
cd curl-android-ios/curl-compile-scripts
git submodule update --init --recursive
NDK_ROOT=`brew --prefix android-ndk` ./build_Android.sh
```
