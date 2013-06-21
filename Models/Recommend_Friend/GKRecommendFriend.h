//
//  GKRecommendFriend.h
//  Grape
//
//  Created by 谢家欣 on 13-5-3.
//  Copyright (c) 2013年 guoku. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "GKUser.h"

@interface GKRecommendFriend : NSObject

+ (void)RecommendFriendWithPage:(NSUInteger)page Block:(void (^)(NSArray * friendList, NSError * error))block;
@end
