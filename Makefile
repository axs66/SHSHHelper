ARCHS = arm64 arm64e
TARGET = iphone:clang:latest:latest

include $(THEOS)/makefiles/common.mk

# Tweak 部分
TWEAK_NAME = SHSHHelper
SHSHHelper_FILES = Tweak.xm SHSHHelper.xm
SHSHHelper_FRAMEWORKS = UIKit

# Control Center 模块部分
CCMODULE_NAME = SHSHHelperCC
SHSHHelperCC_FILES = SHSHHelperCCModule.xm
SHSHHelperCC_FRAMEWORKS = UIKit ControlCenterUIKit

# 使用 Theos 自带的模块模板
include $(THEOS_MAKE_PATH)/tweak.mk
include $(THEOS_MAKE_PATH)/ccmodule.mk
