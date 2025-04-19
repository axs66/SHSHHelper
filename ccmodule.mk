# 控制中心模块 Makefile 配置
CONTROL_CENTER_MODULE_NAME = $(notdir $(CURDIR))
CONTROL_CENTER_MODULE_FILES = SHSHHelperCCModule.xm
CONTROL_CENTER_MODULE_FRAMEWORKS = UIKit ControlCenterUIKit

include $(THEOS)/makefiles/ccmodule.mk
