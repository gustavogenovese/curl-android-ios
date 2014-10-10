ifeq ($(TARGET_ARCH),x86)
  LOCAL_CFLAGS := -O3 -Os 
endif
ifeq ($(TARGET_ARCH),arm)
  LOCAL_CFLAGS := -O3 -Os -mfpu=vfp -mfloat-abi=softfp -fno-short-enums
endif
ifeq ($(TARGET_ARCH),mips)
  LOCAL_CFLAGS := -O3 -Os 
endif
