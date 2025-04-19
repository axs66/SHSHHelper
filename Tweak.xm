#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "Settings.h"

// ✅ 工具函数：获取 ECID（从 IORegistry 读取）
NSString *getECID() {
    NSString *ecid = nil;
    FILE *pipe = popen("ioreg -d2 -c AppleMobileApNonce -a | plutil -extract ECID xml1 -o - - | plutil -p -", "r");
    if (pipe) {
        char buffer[512];
        NSMutableString *result = [NSMutableString string];
        while (fgets(buffer, sizeof(buffer), pipe)) {
            [result appendString:[NSString stringWithUTF8String:buffer]];
        }
        pclose(pipe);

        NSRange range = [result rangeOfString:@"\""];
        if (range.location != NSNotFound) {
            ecid = [[result componentsSeparatedByString:@"\""][1] uppercaseString];
        }
    }
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
