#import <UIKit/UIKit.h>
#import "Settings.h"
#import "SettingsViewController.h"  // 引入完整的 SettingsViewController.h

%hook SettingsViewController

// 覆写 viewDidLoad 方法
- (void)viewDidLoad {
    %orig;

    // 获取 Settings 实例
    Settings *settings = [[Settings alloc] init];

    // 获取 ECID 和型号
    NSString *ecid = [settings getECID];
    NSString *deviceModel = [settings getDeviceModel];

    // 创建显示 ECID 和型号的 UILabel
    UILabel *ecidLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 50, 300, 30)];
    ecidLabel.text = [NSString stringWithFormat:@"ECID: %@", ecid];
    ecidLabel.font = [UIFont systemFontOfSize:16];
    [self.view addSubview:ecidLabel];

    UILabel *modelLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 90, 300, 30)];
    modelLabel.text = [NSString stringWithFormat:@"型号: %@", deviceModel];
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

// 复制 ECID 到剪贴板
- (void)copyECID {
    NSString *ecid = getECID();
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = ecid;
}

// 打开 TSS Saver 链接
- (void)openSHSHLink {
    NSString *ecid = getECID();
    NSString *shshURL = [NSString stringWithFormat:@"https://tsssaver.inkyra.com/?ecid=%@", ecid];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:shshURL] options:@{} completionHandler:nil];
}

%end
