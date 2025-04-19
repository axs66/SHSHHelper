ARCHS = arm64 arm64e
TARGET = iphone:clang:latest:latest

include $(THEOS)/makefiles/common.mk

# Tweak 模块配置
TWEAK_NAME = SHSHHelper
SHSHHelper_FILES = Tweak.xm SHSHHelper.xm SHSHHelperCCModule.xm SettingsViewController.m Settings.m
SHSHHelper_FRAMEWORKS = UIKit Foundation

# 控制中心模块配置
CCMODULE_NAME = SHSHHelperCC
SHSHHelperCC_FILES = SHSHHelperCCModule.xm
SHSHHelperCC_FRAMEWORKS = UIKit ControlCenterUIKit

# 包含的头文件路径
HEADER_SEARCH_PATHS = $(THEOS)/include

# 目标目标文件
include $(THEOS_MAKE_PATH)/tweak.mk

# 合并两个模块为一个 deb 包
internal-stage::
	mkdir -p $(THEOS_STAGING_DIR)/Library/ControlCenter/Bundles
	cp $(THEOS_OBJ_DIR)/SHSHHelperCC.bundle/SHSHHelperCC \
	   $(THEOS_STAGING_DIR)/Library/ControlCenter/Bundles/
	
	# 确保 SHSHHelper.dylib 被拷贝到合适的目录
	mkdir -p $(THEOS_STAGING_DIR)/Library/MobileSubstrate/DynamicLibraries
	cp $(THEOS_OBJ_DIR)/SHSHHelper.dylib $(THEOS_STAGING_DIR)/Library/MobileSubstrate/DynamicLibraries/
