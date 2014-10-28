#ARM optimizations
ifeq ($(TARGET_ARCH),arm)
  LOCAL_CFLAGS := -O3 -Os -mfpu=vfp -mfloat-abi=softfp -fno-short-enums
endif
ifeq ($(TARGET_ARCH),arm64)
  LOCAL_CFLAGS := -O3 -Os -mfpu=vfp -mfloat-abi=softfp -fno-short-enums
endif

#x86 optimizations
ifeq ($(TARGET_ARCH),x86)
  LOCAL_CFLAGS := -O3 -Os
endif
ifeq ($(TARGET_ARCH),x86_64)
  LOCAL_CFLAGS := -O3 -Os
endif

#MIPS optimizations
ifeq ($(TARGET_ARCH),mips)
  LOCAL_CFLAGS := -O3 -Os 
endif
ifeq ($(TARGET_ARCH),mips64)
  LOCAL_CFLAGS := -O3 -Os
endif
