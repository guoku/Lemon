//
//  GKGKFollowerMessage.m
//  Grape
//
//  Created by 谢 家欣 on 13-4-22.
//  Copyright (c) 2013年 guoku. All rights reserved.
//

#import "GKFollowerMessage.h"
#import "GKUser.h"

@implementation GKFollowerMessage
@synthesize user = _user;

- (id)initWithAttributes:(NSDictionary *)attributes
{
    self = [super init];
    if (self)
    {
        _user = [[GKUser alloc] initWithAttributes:[attributes valueForKeyPath:@"follower"]];
    }
    return self;
}

@end
