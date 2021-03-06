LOCAL_PATH := $(call my-dir)
GIT_VERSION := " $(shell git rev-parse --short HEAD)"

include $(CLEAR_VARS)

LOCAL_MODULE    := NP2kai

ifeq ($(TARGET_ARCH_ABI), armeabi)
LOCAL_CFLAGS += -DANDROID_ARM
endif

ifeq ($(TARGET_ARCH_ABI), armeabi-v7a)
LOCAL_CFLAGS += -DANDROID_ARM
endif

ifeq ($(TARGET_ARCH_ABI), arm64-v8a)
LOCAL_CFLAGS += -DANDROID_ARM
endif

ifeq ($(TARGET_ARCH_ABI), x86)
LOCAL_CFLAGS +=  -DANDROID_X86
endif

ifeq ($(TARGET_ARCH_ABI), x86_64)
LOCAL_CFLAGS +=  -DANDROID_X86
endif

ifeq ($(TARGET_ARCH_ABI), mips)
LOCAL_CFLAGS += -DANDROID_MIPS -D__mips__ -D__MIPSEL__
endif

ifeq ($(TARGET_ARCH_ABI), mips64)
LOCAL_CFLAGS += -DANDROID_MIPS -D__mips__ -D__MIPSEL__
endif

CORE_DIR := ..

SOURCES_C   :=
SOURCES_ASM :=
INCFLAGS :=
COMMONFLAGS :=

include $(CORE_DIR)/sdl2/Makefile.common

INCFLAGS += 	-I$(NP2_PATH)/sdl2/libretro \
		-I$(NP2_PATH)/sdl2/libretro/libretro-common/include \
		-I$(NP2_PATH)/i386c \
		-I$(NP2_PATH)/i386c/ia32 \
		-I$(NP2_PATH)/i386c/ia32/instructions \
		-I$(NP2_PATH)/i386c/ia32/instructions/fpu
SOURCES_C += 	$(NP2_PATH)/sdl2/libretro/libretro-common/compat/compat_strcasestr.c \
		$(NP2_PATH)/sdl2/libretro/libretro-common/compat/compat_strl.c \
		$(NP2_PATH)/sdl2/libretro/libretro-common/compat/compat_posix_string.c \
		$(NP2_PATH)/sdl2/libretro/libretro-common/features/features_cpu.c \
		$(NP2_PATH)/sdl2/libretro/libretro-common/file/file_path.c \
		$(NP2_PATH)/sdl2/libretro/libretro-common/file/retro_stat.c \
		$(NP2_PATH)/sdl2/libretro/libretro-common/streams/file_stream.c \
		$(NP2_PATH)/sdl2/libretro/libretro-common/string/stdstring.c \
		$(NP2_PATH)/sdl2/libretro/libretro.c \
		$(wildcard $(NP2_PATH)/i386c/*.c) \
		$(wildcard $(NP2_PATH)/i386c/ia32/*.c) \
		$(wildcard $(NP2_PATH)/i386c/ia32/instructions/*.c) \
		$(NP2_PATH)/i386c/ia32/instructions/fpu/fpemul_dosbox.c
ifneq ($(platform),win)
SOURCES_C += 	$(NP2_PATH)/sdl2/cmmidi.c \
		$(NP2_PATH)/sdl2/cmserial.c
endif

OBJECTS  = $(SOURCES_CXX:.cpp=.o) $(SOURCES_C:.c=.o)
CXXFLAGS += -D__LIBRETRO__ $(fpic) $(INCFLAGS) $(COMMONFLAGS) -DSUPPORT_LARGE_HDD -DSUPPORT_VPCVHD -DSUPPORT_KAI_IMAGES -DHOOK_SYSKEY -DALLOW_MULTIRUN
CFLAGS   += -D__LIBRETRO__ $(fpic) $(INCFLAGS) $(COMMONFLAGS) -DSUPPORT_LARGE_HDD -DSUPPORT_VPCVHD -DSUPPORT_KAI_IMAGES -DHOOK_SYSKEY -DALLOW_MULTIRUN
LDFLAGS  += -lm -lpthread $(fpic)
ifeq ($(platform), unix)
CXXFLAGS += -DSUPPORT_NET -DSUPPORT_LGY98
CFLAGS   += -DSUPPORT_NET -DSUPPORT_LGY98
endif

LOCAL_SRC_FILES := $(SOURCES_C) $(SOURCES_CXX) $(SOURCES_ASM)
LOCAL_CFLAGS += -O3 $(COMMONFLAGS) $(CFLAGS) -DFRONTEND_SUPPORTS_RGB565 $(INCFLAGS) -DGIT_VERSION=\"$(GIT_VERSION)\"
LOCAL_CXXFLAGS += -O3 $(COMMONFLAGS) $(CXXFLAGS) -DFRONTEND_SUPPORTS_RGB565 $(INCFLAGS) -DGIT_VERSION=\"$(GIT_VERSION)\"

include $(BUILD_SHARED_LIBRARY)
