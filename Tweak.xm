@import UIKit;
@import Foundation;
@import Darwin;

#import "Settings.h"

// ✅ 获取设备 ECID
NSString *getECID() {
    Settings *settings = [[Settings alloc] init];
    NSString *ecid = [settings getECID];
    return ecid ?: @"未知";
}

// ✅ 获取设备型号
NSString *getDeviceModel() {
    size_t size;
    sysctlbyname("hw.model", NULL, &size, NULL, 0);
    char *model = (char *)malloc(size);
    sysctlbyname("hw.model", model, &size, NULL, 0);
    NSString *result = [NSString stringWithUTF8String:model];
    free(model);
    return result ?: @"未知型号";
}

// ✅ 复制 ECID
void copyECID() {
    NSString *ecid = getECID();
    if (ecid) {
        [UIPasteboard generalPasteboard].string = ecid;
    }
}

// ✅ 跳转 SHSH 保存站点
void openSHSHSaver() {
    NSString *ecid = getECID();
    if (ecid) {
        NSString *url = [NSString stringWithFormat:@"https://tsssaver.1conan.com?ecid=%@", ecid];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url] options:@{} completionHandler:nil];
    }
}
