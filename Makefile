ARCHS = arm64 arm64e
TARGET := iphone:clang:latest:14.0

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = DarkScript

DarkScript_FILES = Tweak.mm
DarkScript_FRAMEWORKS = UIKit

include $(THEOS_MAKE_PATH)/tweak.mk
