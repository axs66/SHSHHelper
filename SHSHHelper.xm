// 导入所需的头文件
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

%hook Settings

- (void)viewDidLoad {
    %orig;

    // 创建显示 ECID 和型号的 UILabel
    UILabel *ecidLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 50, 300, 30)];
    ecidLabel.text = [NSString stringWithFormat:@"ECID: %@", [self getECID]];
    ecidLabel.font = [UIFont systemFontOfSize:16];
    [self.view addSubview:ecidLabel];
    
    UILabel *modelLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 90, 300, 30)];
    modelLabel.text = [NSString stringWithFormat:@"型号: %@", [self getDeviceModel]];
    modelLabel.font = [UIFont systemFontOfSize:16];
    [self.view addSubview:modelLabel];
    
    // 创建复制 ECID 按钮
    UIButton *copyButton = [UIButton buttonWithType:UIButtonTypeSystem];
    copyButton.frame = CGRectMake(20, 130, 150, 40);
    [copyButton setTitle:@"复制 ECID" forState:UIControlStateNormal];
    [copyButton addTarget:self action:@selector(copyECID) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:copyButton];
    
    // 创建跳转 TSS Saver 按钮
    UIButton *saveButton = [UIButton buttonWithType:UIButtonTypeSystem];
    saveButton.frame = CGRectMake(20, 180, 150, 40);
    [saveButton setTitle:@"保存 SHSH" forState:UIControlStateNormal];
    [saveButton addTarget:self action:@selector(openSHSHLink) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:saveButton];
}

// 获取 ECID（从系统配置文件中读取）
- (NSString *)getECID {
    NSString *ecid = [NSString stringWithContentsOfFile:@"/System/Library/Lockdown/activation_record.plist" encoding:NSUTF8StringEncoding error:nil];
    // 提取 ECID 字段（十六进制）
    return [ecid stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

// 获取设备型号（如 iPhone15,2）
- (NSString *)getDeviceModel {
    return [[UIDevice currentDevice] model];
}

// 复制 ECID 到剪贴板
- (void)copyECID {
    NSString *ecid = [self getECID];
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = ecid;
}

// 打开 TSS Saver 链接
- (void)openSHSHLink {
    NSString *ecid = [self getECID];
    NSString *shshURL = [NSString stringWithFormat:@"https://tsssaver.inkyra.com/?ecid=%@", ecid];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:shshURL] options:@{} completionHandler:nil];
}

%end
