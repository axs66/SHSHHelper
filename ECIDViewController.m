#import "ECIDViewController.h"

@implementation ECIDViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor systemBackgroundColor];
    self.title = @"SHSHHelper";

    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 100, self.view.frame.size.width - 40, 60)];
    label.textAlignment = NSTextAlignmentCenter;
    label.numberOfLines = 0;
    label.text = [NSString stringWithFormat:@"ECID: %@", [self getECID]];
    [self.view addSubview:label];

    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.frame = CGRectMake(60, 200, self.view.frame.size.width - 120, 44);
    [button setTitle:@"打开 SHSH 保存网站" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(openSHSHWebsite) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

- (NSString *)getECID {
    return [[NSFileManager defaultManager] stringWithFileSystemRepresentation:getenv("ECID") length:strlen(getenv("ECID"))] ?: @"未知";
}

- (void)openSHSHWebsite {
    NSString *ecid = [self getECID];
    NSString *urlStr = [NSString stringWithFormat:@"https://shsh.host/#/%@", ecid];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlStr] options:@{} completionHandler:nil];
}

@end
