#import <objc/runtime.h>
#import <Foundation/Foundation.h>

unsigned long long hook_isOpenNewBackup(id self, SEL _cmd) {
    return 1;
}

__attribute__((constructor)) void Inject_WCABTestLocalBackup() {
	/*使用这种写法是因为微信对此函数也有热更新 延迟再Hook即可生效*/
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    Class cls = objc_getClass("WXGRoamBackupPackageService");
    Method md = class_getInstanceMethod(cls, @selector(isOpenNewBackup));
    if (md) {
    class_replaceMethod(cls, @selector(isOpenNewBackup), (IMP)hook_isOpenNewBackup, method_getTypeEncoding(md));
    }
    });
}
