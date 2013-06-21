//
//  GKWeiboFriendJoinMessage.m
//  Grape
//
//  Created by 谢 家欣 on 13-5-13.
//  Copyright (c) 2013年 guoku. All rights reserved.
//

#import "GKWeiboFriendJoinMessage.h"

@implementation GKWeiboFriendJoinMessage


@synthesize recommended_user = _recommended_user;
@synthesize weibo_id = _weibo_id;
@synthesize nickname = _nickname;
@synthesize weibo_screen_name = _weibo_screen_name;


- (id)initWithAttributes:(NSDictionary *)attributes
{

    self = [super init];
    if (self)
    {
        _recommended_user = [[GKUser alloc] initWithAttributes:[attributes valueForKeyPath:@"recommended_user"]];
        _weibo_id = [[attributes valueForKeyPath:@"weibo_id"] longLongValue];
        _nickname = [attributes valueForKeyPath:@"nickname"];
        _weibo_screen_name = [attributes valueForKeyPath:@"weibo_screen_name"];
    }
    
    return self;

}

@end
