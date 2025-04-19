#import "SettingsController.xm"

%hook SettingsController

- (void)viewDidLoad {
    %orig;

    // 添加保存设置按钮
    UIButton *saveButton = [UIButton buttonWithType:UIButtonTypeSystem];
    saveButton.frame = CGRectMake(60, 300, self.view.frame.size.width - 120, 44);
    [saveButton setTitle:@"保存设置" forState:UIControlStateNormal];
    [saveButton addTarget:self action:@selector(saveSettings) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:saveButton];
}

- (void)saveSettings {
    [[Settings sharedInstance] saveSettings];
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"保存成功"
                                                                   message:@"您的设置已成功保存"
                                                            preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:action];
    [self presentViewController:alert animated:YES completion:nil];
}

%end
