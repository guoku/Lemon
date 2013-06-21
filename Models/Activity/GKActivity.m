//
//  GKActivity.m
//  Grape
//
//  Created by 谢 家欣 on 13-4-22.
//  Copyright (c) 2013年 guoku. All rights reserved.
//

#import "GKActivity.h"
#import "GKAppDotNetAPIClient.h"
#import "NSDate+GKHelper.h"
#import "NSDictionary+GKHelp.h"
#import "GKUser.h"

@implementation GKActivity
//@synthesize activity_id = _activity_id;
@synthesize owner_id = _owner_id;
@synthesize count = _count;
@synthesize acting_user = _acting_user;
@synthesize created_time = _created_time;
@synthesize updated_time = _updated_time;
@synthesize type = _type;
@synthesize activity_object = _activity_object;

- (id)initWithAttributes:(NSDictionary *)attributes
{
    self = [super init];
    if (self)
    {
        _owner_id = [[attributes valueForKeyPath:@"owner_id"] integerValue];
        _count = [[attributes valueForKeyPath:@"count"] integerValue];
        _acting_user = [[GKUser alloc] initWithAttributes:[attributes valueForKeyPath:@"acting_user"]];
        _created_time = [NSDate dateFromString:[attributes valueForKeyPath:@"created_time"]];
        _updated_time = [NSDate dateFromString:[attributes valueForKeyPath:@"updated_time"]];
        _type = [attributes valueForKeyPath:@"type"];
        if ([_type isEqualToString:@"post_entity_activity"])
        {
            _activity_object = [[GKEntityActivity alloc] initWithAttributes:[attributes valueForKeyPath:@"object"]];
        } else if ([_type isEqualToString:@"like_entity_activity"])
        {
            _activity_object = [[GKLikeEntityActivity alloc] initWithAttributes:[attributes valueForKeyPath:@"object"]];
        } else if ([_type isEqualToString:@"new_following_activity"])
        {
            _activity_object = [[GKFollowingActivity alloc] initWithAttributes:[attributes valueForKeyPath:@"object"]];
        }
        else if ([_type isEqualToString:@"post_entity_note_activity"])
        {
            _activity_object = [[GKNotesActivity alloc] initWithAttributes:[attributes valueForKeyPath:@"object"]];
        }
    }
    return self;
}


+ (void)getUserActivityWithPostBefore:(NSDate *)postbefore
                                Block:(void (^)(NSArray * activity, NSError * error))block
{
    NSMutableDictionary * _paramters = [NSMutableDictionary dictionaryWithCapacity:1];
    if (!postbefore)
    {
        NSString * dateString  = [NSDate now];
        [_paramters setValue:dateString forKey:@"post_before"];
    } else {
        [_paramters setValue:[NSDate stringFromDate:postbefore] forKey:@"post_before"];
    }
    GKLog(@"time time %@", _paramters);
    [[GKAppDotNetAPIClient sharedClient] postPath:@"user/activity/" parameters:[_paramters Paramters] success:^(AFHTTPRequestOperation *operation, id JSON) {
        GKLog(@"Activity %@", JSON);
            NSUInteger res_code = [[JSON valueForKeyPath:@"res_code"] integerValue];
            NSError * aError;
            NSArray * list_activity = [[JSON valueForKeyPath:@"results"] valueForKeyPath:@"data"];
            NSMutableArray * _mutableArray = [NSMutableArray arrayWithCapacity:[list_activity count]];
            switch (res_code) {
                case SUCCESS:
                {
                    for (NSDictionary * attributres in list_activity)
                    {
                        GKActivity * activiy = [[GKActivity alloc] initWithAttributes:attributres];
                        [_mutableArray addObject:activiy];
                    }
                    if (block)
                    {
                        block([NSArray arrayWithArray:_mutableArray], nil);
                    }
                }
                    break;
                case OBJECT_EMPTY:
                {
                    NSString * errorMsg = [JSON valueForKeyPath:@"res_msg"];
                    NSDictionary * userInfo = [NSDictionary dictionaryWithObject:errorMsg forKey:NSLocalizedDescriptionKey];
                    aError = [NSError errorWithDomain:EntityErrorDomain  code:kEntityIsEmpty userInfo:userInfo];
                }
                    break;
                case SESSION_ERROR:
                {
                    NSString * errorMsg = [JSON valueForKeyPath:@"res_msg"];
                    NSDictionary * userInfo = [NSDictionary dictionaryWithObject:errorMsg forKey:NSLocalizedDescriptionKey];
                    aError = [NSError errorWithDomain:UserErrorDomain code:kUserSessionError userInfo:userInfo];
                }
                    break;
                default:
                    break;
            }
            if (res_code != SUCCESS)
            {
                if (block)
                {
                    block([NSArray array], aError);
                }
            }
            

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (block)
        {
            GKLog(@"%@", error);
            block([NSArray array], error);
        }
    }];
}

@end
