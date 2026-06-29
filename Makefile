ARCHS = arm64 arm64e
TARGET := iphone:clang:latest:14.0

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = DarkScript2

DarkScript2_FILES = Tweak.xm
DarkScript2_FRAMEWORKS = UIKit

include $(THEOS_MAKE_PATH)/tweak.mk
