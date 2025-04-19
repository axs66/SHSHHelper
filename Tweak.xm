// Tweak.xm
@import UIKit;
@import Foundation;
@import Darwin;

// 这里定义获取 ECID 的函数
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

// 复制 ECID 到粘贴板
void copyECID() {
    NSString *ecid = getECID();
    if (ecid) {
        [UIPasteboard generalPasteboard].string = ecid;
    }
}

// 跳转到 SHSH 保存网站
void openSHSHSaver() {
    NSString *ecid = getECID();
    if (ecid) {
        NSString *url = [NSString stringWithFormat:@"https://tsssaver.1conan.com?ecid=%@", ecid];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url] options:@{} completionHandler:nil];
    }
}
