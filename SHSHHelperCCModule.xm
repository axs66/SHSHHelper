#import <UIKit/UIKit.h>
#import <ControlCenterUIKit/ControlCenterUIKit.h>
#import "Tweak.xm" // 引入 Tweak.xm 确保 getECID 可用

%hook CCUIControlCenterModule

- (void)configure {
    %orig;
    
    // 获取 ECID
    NSString *ecid = [self getECID];
    
    // 如果 ECID 为空，显示错误消息
    if (ecid.length == 0) {
        ecid = @"无法获取 ECID";
    }
    
    // 创建按钮
    UIButton *ecidButton = [UIButton buttonWithType:UIButtonTypeSystem];
    ecidButton.frame = CGRectMake(20, 20, 250, 40);
    [ecidButton setTitle:[NSString stringWithFormat:@"ECID: %@", ecid] forState:UIControlStateNormal];
    [ecidButton addTarget:self action:@selector(copyECID) forControlEvents:UIControlEventTouchUpInside];
    [ecidButton setBackgroundColor:[UIColor lightGrayColor]];
    [ecidButton.layer setCornerRadius:8.0];
    [self.view addSubview:ecidButton];
    
    // 创建跳转 TSS Saver 按钮
    UIButton *saveButton = [UIButton buttonWithType:UIButtonTypeSystem];
    saveButton.frame = CGRectMake(20, 70, 250, 40);
    [saveButton setTitle:@"保存 SHSH" forState:UIControlStateNormal];
    [saveButton addTarget:self action:@selector(openSHSHLink) forControlEvents:UIControlEventTouchUpInside];
    [saveButton setBackgroundColor:[UIColor blueColor]];
    [saveButton.layer setCornerRadius:8.0];
    [self.view addSubview:saveButton];
}

// 获取 ECID（从系统配置文件中读取）
- (NSString *)getECID {
    NSString *ecid = [NSString stringWithContentsOfFile:@"/System/Library/Lockdown/activation_record.plist" encoding:NSUTF8StringEncoding error:nil];
    // 提取 ECID 字段（十六进制）
    return [ecid stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

// 复制 ECID 到剪贴板
- (void)copyECID {
    NSString *ecid = [self getECID];
    if (ecid.length == 0) {
        ecid = @"无法获取 ECID";
    }
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = ecid;
}

// 打开 TSS Saver 链接
- (void)openSHSHLink {
    NSString *ecid = [self getECID];
    if (ecid.length == 0) {
        ecid = @"无法获取 ECID";
    }
    NSString *shshURL = [NSString stringWithFormat:@"https://tsssaver.inkyra.com/?ecid=%@", ecid];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:shshURL] options:@{} completionHandler:nil];
}

%end
