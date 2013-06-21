//
//  GKRecommendFriend.m
//  Grape
//
//  Created by 谢家欣 on 13-5-3.
//  Copyright (c) 2013年 guoku. All rights reserved.
//

#import "GKRecommendFriend.h"
#import "GKAppDotNetAPIClient.h"
#import "NSDictionary+GKHelp.h"

@implementation GKRecommendFriend

+ (void)RecommendFriendWithPage:(NSUInteger)page Block:(void (^)(NSArray * friendList, NSError * error))block
{
    NSMutableDictionary * paramters = [NSMutableDictionary dictionaryWithCapacity:0];
    [paramters setValue:[NSNumber numberWithInteger:page] forKey:@"page"];
    [[GKAppDotNetAPIClient sharedClient] getPath:@"user/find/friend/" parameters:[paramters Paramters] success:^(AFHTTPRequestOperation *operation, id JSON) {
        GKLog(@"%@", JSON);
        NSUInteger res_code = [[JSON valueForKeyPath:@"res_code"] integerValue];
                NSError * aError;
        switch (res_code) {
            case SUCCESS:
            {
                NSArray * listResponse = [[JSON valueForKeyPath:@"results"] valueForKeyPath:@"data"];
                NSMutableArray * mutableArray = [NSMutableArray arrayWithCapacity:[listResponse count]];
                for (NSDictionary * attributes in listResponse)
                {
                    GKUser * _user = [[GKUser alloc] initWithAttributes:attributes];
                    [mutableArray addObject:_user];
                }
                if (block)
                {
                    block([NSArray arrayWithArray:mutableArray], nil);
                }

            }
                break;
            case RECOMMENDATION_EMPTY_ERROR:
            {
                NSString * errorMsg = [JSON valueForKeyPath:@"res_msg"];
                NSDictionary * userInfo = [NSDictionary dictionaryWithObject:errorMsg forKey:NSLocalizedDescriptionKey];
                aError = [NSError errorWithDomain:ThreePartErrorDomain code:kRecommendationError userInfo:userInfo];
            }
                break;
            case TOKEN_ERROR:
            {
                NSString * errorMsg = [JSON valueForKeyPath:@"res_msg"];
                NSDictionary * userInfo = [NSDictionary dictionaryWithObject:errorMsg forKey:NSLocalizedDescriptionKey];
                aError = [NSError errorWithDomain:ThreePartErrorDomain code:kTokenError userInfo:userInfo];
            }
                break;
            case TOKEN_EXPIRES:
            {
                NSString * errorMsg = [JSON valueForKeyPath:@"res_msg"];
                NSDictionary * userInfo = [NSDictionary dictionaryWithObject:errorMsg forKey:NSLocalizedDescriptionKey];
                aError = [NSError errorWithDomain:ThreePartErrorDomain code:kTokenExpires userInfo:userInfo];
            }
                 break;
            case WEIBO_USER_UPDATING:
            {
                NSString * errorMsg = [JSON valueForKeyPath:@"res_msg"];
                NSDictionary * userInfo = [NSDictionary dictionaryWithObject:errorMsg forKey:NSLocalizedDescriptionKey];
                aError = [NSError errorWithDomain:ThreePartErrorDomain code:kWeiboUserUpdating userInfo:userInfo];
            }
                break;
            default:
                break;

        }
        if (res_code != SUCCESS)
        {
            if (block) {
                block([NSArray array], aError);
            }
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if(block)
        {
            GKLog(@"%@", error);
            block([NSArray array], error);
        }
    }];
}

@end
