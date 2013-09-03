//
//  GKMessages.m
//  Grape
//
//  Created by 谢家欣 on 13-4-19.
//  Copyright (c) 2013年 guoku. All rights reserved.
//

#import "GKMessages.h"
#import "NSDictionary+GKHelp.h"
#import "NSDate+GKHelper.h"
#import "GKAppDotNetAPIClient.h"

@implementation GKMessages

@synthesize type = _type;
@synthesize created_time = _created_time;
@synthesize message_object = _message_object;


- (id)initWithAttributes:(NSDictionary *)attributes
{
    self = [super init];
    if (self)
    {
        _type = [attributes valueForKeyPath:@"type"];
        _created_time = [NSDate  dateFromString:[attributes valueForKeyPath:@"created_time"]];
        if ([_type isEqualToString:@"entity_message"])
        {
            _message_object = [[GKEntityMessage alloc] initWithAttributes:[attributes valueForKeyPath:@"data"]];
        } else if ([_type isEqualToString:@"following"])
        {
            _message_object = [[GKFollowerMessage alloc] initWithAttributes:[attributes valueForKeyPath:@"data"]];
        } else if ([_type isEqualToString:@"post_entity_note"])
        {
            _message_object = [[GKNoteMessage alloc] initWithAttributes:[attributes valueForKeyPath:@"data"]];
        } else if ([_type isEqualToString:@"friend_joined"])
        {
            _message_object = [[GKWeiboFriendJoinMessage alloc] initWithAttributes:[attributes valueForKeyPath:@"data"]];
        }
        else if ([_type isEqualToString:@"poke_note"])
        {
             _message_object = [[GKNoteMessage alloc] initWithAttributes:[attributes valueForKeyPath:@"data"]];
        }
        else if ([_type isEqualToString:@"reply"])
        {
            _message_object = [[GKNoteMessage alloc] initWithAttributes:[attributes valueForKeyPath:@"data"]];
        }
    }
    
    return self;
}

+ (void)getUserUnreadMessageCountWithBlock:(void (^)(NSUInteger count, NSError * error))block
{
    NSDictionary * paramaters = [NSDictionary dictionary];
    if (![kUserDefault valueForKeyPath:kSession])
    {
        return;
    }
    [[GKAppDotNetAPIClient sharedClient] getPath:@"maria/unread_message_count" parameters:[paramaters Paramters] success:^(AFHTTPRequestOperation *operation, id JSON) {
        GKLog(@"%@", JSON);
        NSUInteger res_code = [[JSON valueForKeyPath:@"res_code"] integerValue];
        NSError * aError;
        switch (res_code) {
            case SUCCESS:
            {
                NSUInteger unread_count = 0;
                NSArray * listresponse = [[JSON valueForKeyPath:@"results"] valueForKeyPath:@"data"];
                for (NSDictionary * attributes in listresponse)
                {
                    unread_count = [[attributes valueForKeyPath:@"unread_message_count"] integerValue];
                }
                if (block)
                {
                    block(unread_count, nil);
                }
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
                block(0, aError);
            }
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (block)
        {
            GKLog(@"%@", error);
            block(0, error);
        }
    }];
}

+ (void)getUserMessageWithPostBefore:(NSDate *)postbefore Block:(void (^)(NSArray * messages, NSError * error))block
{
    NSMutableDictionary * paramters = [NSMutableDictionary dictionaryWithCapacity:1];
    if (!postbefore)
    {
        NSString * dataString = [NSDate now];
        [paramters setValue:dataString forKey:@"since_time"];
    } else {
        [paramters setValue:[NSDate stringFromDate:postbefore] forKey:@"since_time"];
    }
    [[GKAppDotNetAPIClient sharedClient] getPath:@"maria/read_message/" parameters:[paramters Paramters] success:^(AFHTTPRequestOperation *operation, id JSON) {
        
       GKLog(@"%@", JSON);
        NSUInteger  res_code = [[JSON valueForKeyPath:@"res_code"] integerValue];
        NSError * aError;
        switch (res_code) {
            case SUCCESS:
            {
                NSArray * listResponse = [[JSON valueForKeyPath:@"results"] valueForKeyPath:@"data"];
                NSMutableArray * _mutablearray = [NSMutableArray arrayWithCapacity:[listResponse count]];
                for (NSDictionary * attributes in listResponse)
                {
                    GKLog(@"%@",attributes);
                    GKMessages * _message = [[GKMessages alloc] initWithAttributes:attributes];
                    [_mutablearray addObject:_message];
                }
                if (block)
                {
                    block([NSArray arrayWithArray:_mutablearray], nil);
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
