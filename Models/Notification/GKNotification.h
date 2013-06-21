//
//  GKNotification.h
//  Grape
//
//  Created by 谢 家欣 on 13-4-30.
//  Copyright (c) 2013年 guoku. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GKNotification : NSObject

+ (void)postNotificationInfoWithDeviceToken:(NSString *)dev_token
                                      Block:(void (^)(BOOL is_success, NSError * error))block;

@end
