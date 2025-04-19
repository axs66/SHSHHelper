#import <UIKit/UIKit.h>
#import <Preferences/PSListController.h>
#import <sys/sysctl.h>
#import <stdlib.h>
#import <Foundation/Foundation.h>

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

// ✅ 获取设备型号（例如 iPhone15,2）
NSString *getDeviceModel() {
    size_t size;
    sysctlbyname("hw.model", NULL, &size, NULL, 0);
    char *model = (char *)malloc(size); // ✅ 强制类型转换
    sysctlbyname("hw.model", model, &size, NULL, 0);
    NSString *result = [NSString stringWithUTF8String:model];
    free(model);
    return result ?: @"未知型号";
}

// ✅ 复制 ECID 到剪贴板
void copyECID() {
    NSString *ecid = getECID();
    if (ecid) {
        [UIPasteboard generalPasteboard].string = ecid;
    }
}

// ✅ 打开 TSS Saver 链接
void openSHSHSaver() {
    NSString *ecid = getECID();
    if (ecid) {
        NSString *url = [NSString stringWithFormat:@"https://tsssaver.1conan.com?ecid=%@", ecid];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url] options:@{} completionHandler:nil];
    }
}

%hook PSListController

- (void)viewDidLoad {
    %orig;

    // 仅注入 SHSHHelper 设置页（根据标题识别）
    if ([self.title.lowercaseString containsString:@"shsh"]) {
        UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.table.bounds.size.width, 200)]; // ✅ 修正

        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 20, header.frame.size.width - 30, 40)];
        label.text = [NSString stringWithFormat:@"ECID: %@", getECID()];
        label.font = [UIFont systemFontOfSize:16];
        [header addSubview:label];

        UILabel *modelLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 60, header.frame.size.width - 30, 40)];
        modelLabel.text = [NSString stringWithFormat:@"型号: %@", getDeviceModel()];
        modelLabel.font = [UIFont systemFontOfSize:16];
        [header addSubview:modelLabel];

        UIButton *copyBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        copyBtn.frame = CGRectMake(15, 110, 150, 35);
        [copyBtn setTitle:@"复制 ECID" forState:UIControlStateNormal];
        [copyBtn addTarget:self action:@selector(copyECIDBtnTapped) forControlEvents:UIControlEventTouchUpInside];
        [header addSubview:copyBtn];

        UIButton *shshBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        shshBtn.frame = CGRectMake(15, 150, 150, 35);
        [shshBtn setTitle:@"跳转保存 SHSH" forState:UIControlStateNormal];
        [shshBtn addTarget:self action:@selector(openSHSHSaverBtnTapped) forControlEvents:UIControlEventTouchUpInside];
        [header addSubview:shshBtn];

        self.table.tableHeaderView = header;
    }
}

%new
- (void)copyECIDBtnTapped {
    copyECID();
}

%new
- (void)openSHSHSaverBtnTapped {
    openSHSHSaver();
}

%end

// ✅ 控制中心模块（如果你也想 hook 控制中心模块，可以视情况保留）
/* %hook CCUIModuleViewController

- (void)viewDidAppear:(BOOL)animated {
    %orig;

    if ([self.description containsString:@"SHSHHelper"]) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 280, 20)];
        label.text = [NSString stringWithFormat:@"ECID: %@", getECID()];
        label.font = [UIFont systemFontOfSize:12];
        [self.view addSubview:label];

        UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
        btn.frame = CGRectMake(10, 35, 100, 30);
        [btn setTitle:@"复制 ECID" forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(ccCopyECIDTapped) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btn];

        UIButton *btn2 = [UIButton buttonWithType:UIButtonTypeSystem];
        btn2.frame = CGRectMake(120, 35, 140, 30);
        [btn2 setTitle:@"跳转保存 SHSH" forState:UIControlStateNormal];
        [btn2 addTarget:self action:@selector(ccSHSHTapped) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btn2];
    }
}

%new
- (void)ccCopyECIDTapped {
    copyECID();
}

%new
- (void)ccSHSHTapped {
    openSHSHSaver();
}

%end */
