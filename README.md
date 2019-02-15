curl-android-ios
================
The goal of this project is to provide a pre-compiled version of libcurl to be
used in Android and iOS.

It uses cURL from the upstream repository and it's updated frequently.

For Android, it also uses OpenSSL from its upstream repository.

If you want to build the library, scripts are provided for both platforms.
Test projects are also provided for both iOS and Android.

# Building
* Clone this repo `git clone git@github.com:gcesarmza/curl-android-ios.git`
* Clone submodules `git submodule init && git submodule update`
* Make sure you have installed `autoconf`, `automake` and `libtool` or install them with `apt-get` or `brew`
* When building on Mac OS make sure you have Xcode Command Line Developer Tools installed
```
xcode-select --install
```
* When building on Mac OS Mojave an additional step is required:
```
open /Library/Developer/CommandLineTools/Packages/macOS_SDK_headers_for_macOS_10.14.pkg
```


## Building for Android:
* Download Android NDK
```
cd curl-android-ios/curl-compile-scripts
export NDK_ROOT=PATH_WHERE_NDK_IS
./build_Android.sh
```

## Building for iOS
```
cd curl-android-ios/curl-compile-scripts
./build_iOS.sh
```
