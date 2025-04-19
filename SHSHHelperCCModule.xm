#import "SHSHHelperCore.xm"

%hook SHSHHelper

- (NSString *)getSHSHForECID:(NSString *)ecid {
    // 模拟从 SHSH 保存网站获取数据
    NSString *shshUrl = [NSString stringWithFormat:@"https://shsh.host/#/%@", ecid];
    return shshUrl;
}

%end
