//
//  GKFollowingActivity.m
//  Grape
//
//  Created by 谢 家欣 on 13-4-23.
//  Copyright (c) 2013年 guoku. All rights reserved.
//

#import "GKFollowingActivity.h"
#import "NSDate+GKHelper.h"
#import "GKUser.h"

@implementation GKFollowingActivity

@synthesize users = _users;

- (id)initWithAttributes:(NSDictionary *)attributes
{
    self = [super init];
    if (self)
    {
        _users = [NSMutableArray arrayWithCapacity:[[attributes valueForKeyPath:@"following_users"] count]];
        for (NSDictionary * userDict in [attributes valueForKeyPath:@"following_users"])
        {
            GKUser * _user = [[GKUser alloc] initWithAttributes:userDict];
            [_users addObject:_user];
        }
        _active_date = [NSDate dateFromString:[attributes valueForKeyPath:@"active_date"]];
    }
    return self;
}


@end
