#import <Foundation/Foundation.h>

@interface Settings : NSObject

+ (instancetype)sharedInstance;
- (void)saveSettings;
- (void)loadSettings;

@end
