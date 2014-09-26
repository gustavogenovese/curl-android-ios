LOCAL_PATH := $(call my-dir)

include $(CLEAR_VARS)
LOCAL_MODULE := curl-prebuilt
LOCAL_SRC_FILES := ../../../curl-compile-scripts/obj/local/$(TARGET_ARCH_ABI)/libcurl.a
include $(PREBUILT_STATIC_LIBRARY)


include $(CLEAR_VARS)
LOCAL_MODULE := testlibrary
LOCAL_SRC_FILES := ../testlibrary.cpp
LOCAL_STATIC_LIBRARIES := curl-prebuilt

COMMON_CFLAGS := -Werror -DANDROID
COMMON_CFLAGS += -I$(NDK_PATH)/platforms/$(TARGET_PLATFORM)/arch-arm/usr/include
COMMON_CFLAGS += -I$(LOCAL_PATH)/../../../curl/include

ifeq ($(TARGET_ARCH),x86)
    LOCAL_CFLAGS := $(COMMON_CFLAGS)
else
    LOCAL_CFLAGS := -mfpu=vfp -mfloat-abi=softfp -fno-short-enums $(COMMON_CFLAGS)
endif

LOCAL_LDLIBS := -lz -llog -Wl,-s
LOCAL_CPPFLAGS += -std=gnu++0x

include $(BUILD_SHARED_LIBRARY)
