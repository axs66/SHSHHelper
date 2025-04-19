ARCHS = arm64 arm64e
TARGET = iphone:clang:latest:latest

include $(THEOS)/makefiles/common.mk

# Tweak 部分
TWEAK_NAME = SHSHHelper
SHSHHelper_FILES = Tweak.xm SHSHHelper.xm
SHSHHelper_FRAMEWORKS = UIKit

# Control Center 模块（ccmodule.mk 中继续定义具体内容）
include $(THEOS_MAKE_PATH)/tweak.mk
include ccmodule.mk   # ✅ 本地路径，引入项目根目录下的 ccmodule.mk
