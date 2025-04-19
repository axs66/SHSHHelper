#import <UIKit/UIKit.h>
#import "ECIDViewController.h"  // 导入新的视图控制器

%hook Settings

- (void)viewDidLoad {
    %orig;
    
    ECIDViewController *ecidVC = [[ECIDViewController alloc] init];
    // 如果使用导航控制器（如果存在），将其推送
    [self.navigationController pushViewController:ecidVC animated:YES];
}

%end
