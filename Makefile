ARCHS = arm64 arm64e
DEBUG = 0
FINALPACKAGE = 1

TARGET = iphone:clang:14.5:14.5
THEOS_PACKAGE_SCHEME = rootless

include $(THEOS)/makefiles/common.mk

# Options globales pour compiler l'Objective-C++ et le C++ standard
ADDITIONAL_CFLAGS = -fobjc-arc -std=c++11 -stdlib=libc++
ADDITIONAL_OBJCCFLAGS = -std=c++11 -stdlib=libc++
ADDITIONAL_LDFLAGS = -stdlib=libc++

TWEAK_NAME = SilentPwn

# Frameworks et bibliothèques statiques du projet
SilentPwn_FRAMEWORKS = UIKit Foundation QuartzCore
SilentPwn_LIBRARIES += substrate
SilentPwn_LDFLAGS += $(THEOS_PROJECT_DIR)/Lib/Keystone/arm64/libkeystone.a
SilentPwn_CFLAGS += -I$(THEOS_PROJECT_DIR)/Lib/Keystone/includes

# Fichiers sources à inclure à la compilation
SilentPwn_FILES = Tweak.mm \
	$(wildcard Source/Memory/Kitty/*.cpp) \
	$(wildcard Source/Memory/Kitty/*.mm) \
	$(wildcard Source/UI/*.mm) \
	$(wildcard Source/Memory/Hook/*.mm) \
	$(wildcard Source/Memory/Patch/*.mm) \
	$(wildcard Source/Memory/Helper.mm) \
	$(wildcard Source/Framework/*.mm) \
	$(wildcard Source/Memory/Thread/*.mm)

include $(THEOS_MAKE_PATH)/tweak.mk
