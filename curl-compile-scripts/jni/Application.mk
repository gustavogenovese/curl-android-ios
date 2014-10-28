APP_OPTIM := release
APP_PLATFORM := android-8
APP_STL := gnustl_static
APP_CPPFLAGS += -frtti
APP_CPPFLAGS += -fexceptions
APP_CPPFLAGS += -DANDROID
APP_ABI := arm64-v8a x86_64 mips64 armeabi armeabi-v7a x86 mips
APP_MODULES := ssl crypto curl
NDK_TOOLCHAIN_VERSION := clang
 
