THEOS_PACKAGE_SCHEME = rootless
ARCHS = arm64 arm64e
TARGET = iphone:clang:latest:15.0

INSTALL_TARGET_PROCESSES = Happ

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = HappSkyBackground
HappSkyBackground_FILES = Tweak.x
HappSkyBackground_CFLAGS = -fobjc-arc
HappSkyBackground_FRAMEWORKS = UIKit

include $(THEOS_MAKE_PATH)/tweak.mk
