#import <Foundation/Foundation.h>

@interface Settings : NSObject

// 获取设备 ECID
+ (NSString *)getECID;

// 获取设备型号
+ (NSString *)getDeviceModel;

@end
