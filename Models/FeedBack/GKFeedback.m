//
//  GKFeedback.m
//  Grape
//
//  Created by 谢 家欣 on 13-4-23.
//  Copyright (c) 2013年 guoku. All rights reserved.
//

#import "GKFeedback.h"
#import "GKAppDotNetAPIClient.h"
#import "GKDevice.h"
#import "NSDictionary+GKHelp.h"
//#import "UIDevice-Hardware.h"

@implementation GKFeedback


+ (void)postFeedBackWittContent:(NSString *)content Block:(void (^)(BOOL is_success, NSError * error))block
{
    NSMutableDictionary * paramters = [NSMutableDictionary dictionaryWithCapacity:5];
    [paramters setValue:content forKey:@"feedback"];
    [paramters setValue:[GKDevice platform] forKey:@"platform"];
    [paramters setValue:[GKDevice appVersion] forKey:@"app_ver"];
    [paramters setValue:[GKDevice systemVersion] forKey:@"sys_ver"];
    
    [[GKAppDotNetAPIClient sharedClient] postPath:@"feedback/" parameters:[paramters Paramters] success:^(AFHTTPRequestOperation *operation, id JSON) {
        GKLog(@"%@", JSON);
        NSUInteger res_code = [[JSON valueForKeyPath:@"res_code"] integerValue];
        switch (res_code) {
            case SUCCESS:
            {
                if (block)
                {
                    block(YES, nil);
                }
            }
                break;
                
            default:
                break;
            if (res_code != SUCCESS)
            {
                if (block)
                {
                    block(NO, nil);
                }
            }
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
