//
//  GKNotification.m
//  Grape
//
//  Created by 谢 家欣 on 13-4-30.
//  Copyright (c) 2013年 guoku. All rights reserved.
//

#import "GKNotification.h"
#import "GKAppDotNetAPIClient.h"
#import "NSDictionary+GKHelp.h"
#import "GKDevice.h"

@implementation GKNotification


+ (void)postNotificationInfoWithDeviceToken:(NSString *)dev_token
                                      Block:(void (^)(BOOL is_success, NSError * error))block
{
    
    NSString * dev_name = [GKDevice platform];
    NSString * dev_model = [GKDevice modle];
    NSString * sys_ver = [GKDevice systemVersion];
    NSString * app_ver = [GKDevice appVersion];
    NSString * app_name = [GKDevice appName];
    NSUInteger rntypes = [[UIApplication sharedApplication] enabledRemoteNotificationTypes];
    
    NSString * push_badge = (rntypes & UIRemoteNotificationTypeBadge) ? @"enabled" : @"disabled";
    NSString * push_alert = (rntypes & UIRemoteNotificationTypeAlert) ? @"enabled" : @"disabled";
    NSString * push_sound = (rntypes & UIRemoteNotificationTypeSound) ? @"enabled" : @"disabled";
    
    
    NSMutableDictionary * paramters = [NSMutableDictionary dictionaryWithCapacity:1];
    [paramters setValue:dev_token forKey:@"dev_token"];
    [paramters setValue:dev_name forKey:@"dev_name"];
    [paramters setValue:dev_model forKey:@"dev_model"];
    [paramters setValue:sys_ver forKey:@"sys_ver"];
    [paramters setValue:app_name forKey:@"app_name"];
    [paramters setValue:app_ver forKey:@"app_ver"];
    [paramters setValue:push_badge forKey:@"push_badge"];
    [paramters setValue:push_alert forKey:@"push_alert"];
    [paramters setValue:push_sound forKey:@"push_sound"];
    
//    NSUserDefaults * userdefault = [NSUserDefaults standardUserDefaults];
    [kUserDefault setValue:dev_token forKey:kDeviceToken];
    [kUserDefault synchronize];
#ifdef DEBUG
    [paramters setValue:@"sandbox" forKey:@"development"];
#else
    [paramters setValue:@"production" forKey:@"development"];
#endif
//    GKLog(@"%@", paramters);
    [[GKAppDotNetAPIClient sharedClient] postPath:@"apns/" parameters:[paramters Paramters] success:^(AFHTTPRequestOperation *operation, id JSON) {
        GKLog(@"%@", JSON);
        if (block)
        {
            block(YES, nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (block)
        {
            GKLog(@"%@", error);
            block(NO, error);
        }
    }];
}

@end
