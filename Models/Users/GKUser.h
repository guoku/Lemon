//
//  GKUser.h
//  Grape
//
//  Created by 谢家欣 on 13-3-23.
//  Copyright (c) 2013年 guoku. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import "GKUserBase.h"
#import "GKUserAvatar.h"
#import "GKUserWeiboToken.h"
#import "GKUserTaobaoToken.h"
#import "GKUserRelation.h"

extern NSString * const GKUserLoginNotification;
extern NSString * const GKUserLogoutNotification;

typedef enum {
    GKWeiboURLType = 1,
    GKTaobaoURLType,
} GKThreePartAccountURL;

@interface GKUser : NSObject

@property (readonly) NSUInteger user_id;
@property (readonly) NSString * username;
@property (readonly) NSString * nickname;
@property (readonly) NSString * gender;
@property (readonly) NSString * location;
@property (readonly) NSString * email;
@property (readonly) NSString * website;
@property (readonly) NSString * bio;
@property (readonly) NSString * session;
@property (readonly) NSDate * birth_date;

@property (readwrite) BOOL email_verified;
@property (readwrite) NSUInteger liked_count;
@property (readwrite) NSUInteger post_entities;
@property (readwrite) NSUInteger post_entity_notes;
@property (readwrite) NSUInteger tags;
@property (readwrite) NSUInteger followings;
@property (readwrite) NSUInteger fans;
@property (nonatomic, strong) GKUserRelation * relation;
@property (nonatomic, strong) GKUserAvatar * avatars;
@property (nonatomic, strong) GKUserWeiboToken * weibo_token;
@property (nonatomic, strong) GKUserTaobaoToken * taobao_token;

- (id)initFromSQLite;
- (id)initWithAttributes:(NSDictionary *)attributes;
- (BOOL)removeFromSQLite;
- (GKUser *)save;

+ (void)globalUserProfileWithUserID:(NSUInteger)user_id
                                Block:(void (^)( NSDictionary * dict, NSError * error))block;
+ (void)globaluserRegisterWithEmail:(NSString *)email
                                Passwd:(NSString *)passwd
                                NickName:(NSString *)nickname
                                Block:(void (^)(NSDictionary * dict, NSError * error))block;
+ (void)globalUserLoginWithEmail:(NSString *)email passwd:(NSString *)passwd
                                Block:(void (^)(NSDictionary * dict, NSError * error))block;

+ (void)globalUserLogoutWithBlock:(void (^)(BOOL is_logout, NSError * error))block;

+ (void)ForgetPasswdWithEmail:(NSString *)email Block:(void (^)(BOOL is_send_email, NSError * error))block;

+ (void)UserFollowActionWithUserID:(NSUInteger)user_id Action:(GK_USER_RELATION)action
                             Block:(void (^)(NSDictionary * user_relation, NSError * error))block;
+ (void)globalUserFollowingsWithUserID:(NSUInteger)user_id Page:(NSUInteger)page
                                Block:(void (^)(NSArray * following_list, NSError * error))block;

+ (void)globalUserFansWithUserID:(NSUInteger)user_id Page:(NSUInteger)page
                                Block:(void (^)(NSArray * fans_list, NSError * error))block;

+ (void)registerByWeiboOrTaobaoWithParamters:(NSDictionary *)paramters
                                        Type:(GKThreePartAccountURL)type
                                       Block:(void (^)(NSDictionary * dict, NSError * error))block;

+ (void)bindByWeiboOrTaobaoWithParamters:(NSDictionary *)paramters
                                    Type:(GKThreePartAccountURL)type
                                   Block:(void (^)(NSDictionary * dict, NSError * error))block;

@end
