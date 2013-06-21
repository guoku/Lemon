//
//  GKWeiboFriendJoinMessage.h
//  Grape
//
//  Created by 谢 家欣 on 13-5-13.
//  Copyright (c) 2013年 guoku. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "GKUser.h"

@interface GKWeiboFriendJoinMessage : NSObject


@property (readonly) GKUser * recommended_user;
@property (readonly) long long weibo_id;
@property (readonly) NSString * nickname;
@property (readonly) NSString * weibo_screen_name;

- (id)initWithAttributes:(NSDictionary *)attributes;
@end
