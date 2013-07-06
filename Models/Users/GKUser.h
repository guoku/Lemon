//
//  GKUser.h
//  Grape
//
//  Created by 谢家欣 on 13-3-23.
//  Copyright (c) 2013年 guoku. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "GKUserRelation.h"

extern NSString * const GKUserLoginNotification;
extern NSString * const GKUserLogoutNotification;

@interface GKUser : NSObject

@property (readwrite) NSUInteger user_id;
@property (readwrite,strong) NSString * nickname;
@property (readwrite,strong) NSString * gender;
@property (unsafe_unretained, readonly) NSURL * avatarImageURL;
@property (readwrite,strong) NSString * location;
@property (readwrite,strong) NSString * city;
@property (readwrite,strong) NSString * bio;

@property (readwrite) NSUInteger stage;
@property (readwrite,strong) NSDate * birth_date;

@property (readwrite) NSUInteger liked_count;
@property (readwrite) NSUInteger follows_count;
@property (readwrite) NSUInteger fans_count;

@property (nonatomic, strong) GKUserRelation * relation;


- (id)initWithAttributes:(NSDictionary *)attributes;
- (void)save;
- (id)initFromNSU;

+ (void)registerByWeiboOrTaobaoWithParamters:(NSDictionary *)paramters
                                       Block:(void (^)(NSDictionary * dict, NSError * error))block;

+ (void)globalUserLogoutWithBlock:(void (^)(BOOL is_logout, NSError * error))block;

+ (void)globalUserProfileWithUserID:(NSUInteger)user_id
                                Block:(void (^)( NSDictionary * dict, NSError * error))block;

+ (void)UserFollowActionWithUserID:(NSUInteger)user_id Action:(GK_USER_RELATION)action
                             Block:(void (^)(NSDictionary * user_relation, NSError * error))block;
+ (void)globalUserFollowingsWithUserID:(NSUInteger)user_id Page:(NSUInteger)page
                                Block:(void (^)(NSArray * following_list, NSError * error))block;

+ (void)globalUserFansWithUserID:(NSUInteger)user_id Page:(NSUInteger)page
                                Block:(void (^)(NSArray * fans_list, NSError * error))block;


@end
