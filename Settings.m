#import "Settings.h"
#import <UIKit/UIKit.h>
#import <sys/sysctl.h>

@implementation Settings

// 获取设备 ECID
- (NSString *)getECID {
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

// 获取设备型号
- (NSString *)getDeviceModel {
    size_t size;
    sysctlbyname("hw.model", NULL, &size, NULL, 0);
    char *model = (char *)malloc(size);
    if (model) {
        sysctlbyname("hw.model", model, &size, NULL, 0);
        NSString *result = [NSString stringWithUTF8String:model];
        free(model);
        return result ?: @"未知型号";
    }
    return @"未知型号";
}

@end
