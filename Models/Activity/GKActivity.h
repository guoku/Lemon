//
//  GKActivity.h
//  Grape
//
//  Created by 谢 家欣 on 13-4-22.
//  Copyright (c) 2013年 guoku. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "GKEntityActivity.h"
#import "GKLikeEntityActivity.h"
#import "GKFollowingActivity.h"
#import "GKNotesActivity.h"
//#import "GKUser.h"
@class GKUser;

@interface GKActivity : NSObject

//@property (readonly) NSString * activity_id;
@property (readonly) NSUInteger owner_id;
@property (readonly) NSUInteger count;
@property (readonly) GKUser * acting_user;
@property (readonly) NSDate * created_time;
@property (readonly) NSDate * updated_time;
@property (readonly) NSString * type;
@property (readonly) id activity_object;

- (id)initWithAttributes:(NSDictionary *)attributes;
+ (void)getUserActivityWithPostBefore:(NSDate *)postbefore
                                Block:(void (^)(NSArray * activity, NSError * error))block;
@end
