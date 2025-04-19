#import "Settings.h"

@implementation Settings

- (NSString *)getECID {
    // 获取 ECID 的实现
    NSString *ecid = [NSString stringWithContentsOfFile:@"/System/Library/Lockdown/activation_record.plist" encoding:NSUTF8StringEncoding error:nil];
    return [ecid stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

- (NSString *)getDeviceModel {
    // 获取设备型号
    return [[UIDevice currentDevice] model];
}

@end
