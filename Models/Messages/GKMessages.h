//
//  GKMessages.h
//  Grape
//
//  Created by 谢家欣 on 13-4-19.
//  Copyright (c) 2013年 guoku. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "GKEntityMessage.h"
#import "GKFollowerMessage.h"
#import "GKNoteMessage.h"
#import "GKWeiboFriendJoinMessage.h"
@interface GKMessages : NSObject

@property (readonly) NSString * type;
@property (readonly) NSDate * created_time;
@property (readonly) id  message_object;


- (id)initWithAttributes:(NSDictionary *)attributes;
+ (void)getUserUnreadMessageCountWithBlock:(void (^)(NSUInteger count, NSError * error))block;
+ (void)getUserMessageWithPostBefore:(NSDate *)postbefore
                               Block:(void (^)(NSArray * messages, NSError * error))block;
@end
