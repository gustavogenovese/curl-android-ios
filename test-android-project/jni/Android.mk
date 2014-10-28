LOCAL_PATH := $(call my-dir)

#cURL prebuilt
include $(CLEAR_VARS)
LOCAL_MODULE := curl-prebuilt
LOCAL_SRC_FILES := \
  ../../prebuilt-with-ssl/android/$(TARGET_ARCH_ABI)/libcurl.a
include $(PREBUILT_STATIC_LIBRARY)
################################################################################

#Test Library
include $(CLEAR_VARS)
LOCAL_MODULE := testlibrary
LOCAL_SRC_FILES := ../src/native/testlibrary.cpp
LOCAL_STATIC_LIBRARIES := curl-prebuilt 
COMMON_CFLAGS := -Werror -DANDROID 

ifeq ($(TARGET_ARCH),arm)
  LOCAL_CFLAGS := -mfpu=vfp -mfloat-abi=softfp -fno-short-enums
endif

LOCAL_CFLAGS += $(COMMON_CFLAGS)
LOCAL_LDLIBS := -lz -llog -Wl,-s
LOCAL_CPPFLAGS += -std=gnu++0x
LOCAL_C_INCLUDES += \
  $(NDK_PATH)/platforms/$(TARGET_PLATFORM)/arch-$(TARGET_ARCH)/usr/include \
  $(LOCAL_PATH)/../../prebuilt-with-ssl/android/include

include $(BUILD_SHARED_LIBRARY)
################################################################################
