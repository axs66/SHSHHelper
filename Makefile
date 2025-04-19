ARCHS = arm64 arm64e
TARGET = iphone:clang:latest:latest

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = SHSHHelper
SHSHHelper_FILES = Tweak.xm SHSHHelper.xm Settings.m  # 添加 Settings.m 到文件列表
SHSHHelper_FRAMEWORKS = UIKit

CCMODULE_NAME = SHSHHelperCC
SHSHHelperCC_FILES = SHSHHelperCCModule.xm
SHSHHelperCC_FRAMEWORKS = UIKit ControlCenterUIKit

include $(THEOS_MAKE_PATH)/tweak.mk
include $(THEOS_MAKE_PATH)/ccmodule.mk

# 合并两个模块为一个 deb 包
internal-stage::
	mkdir -p $(THEOS_STAGING_DIR)/Library/ControlCenter/Bundles
	cp $(THEOS_OBJ_DIR)/SHSHHelperCC.bundle/SHSHHelperCC \
	   $(THEOS_STAGING_DIR)/Library/ControlCenter/Bundles/
