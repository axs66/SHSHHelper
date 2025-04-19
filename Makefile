ARCHS = arm64 arm64e
TARGET = iphone:clang:latest:14.0
THEOS_PACKAGE_SCHEME = rootless
INSTALL_TARGET_PROCESSES = SpringBoard Preferences

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = SHSHHelper
SHSHHelper_FILES = Tweak.xm SHSHHelperCore.xm SHSHHelperUI.m SHSHHelperCCModule.xm
SHSHHelper_FRAMEWORKS = UIKit Foundation
SHSHHelper_PRIVATE_FRAMEWORKS = Preferences ControlCenterUI

include $(THEOS_MAKE_PATH)/tweak.mk
