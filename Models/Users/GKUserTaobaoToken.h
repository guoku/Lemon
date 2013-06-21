//
//  GKUserTaobaoToken.h
//  Grape
//
//  Created by 谢家欣 on 13-3-23.
//  Copyright (c) 2013年 guoku. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GKUserTaobaoToken : NSObject

@property (readonly) NSUInteger user_id;
@property (readonly) unsigned long long taobao_id;
@property (readonly) NSString * screen_name;
@property (readonly) NSString * access_token;
@property (readonly) NSUInteger expires_in;
@property (readonly) NSUInteger re_expires_in;

- (id)initFromSQLiteWithUserID:(NSUInteger)user_id;
- (id)initWithAttributes:(NSDictionary *)attributes;
- (void)saveToSQLite;
- (BOOL)removeFromSQLite;
//- (BOOL)removeFromSQLiteWithUserID:(NSUInteger)user_id;
//+ (void)bindToTaobaoWithTaobaoID:(unsigned long long)taobao_id
//                      ScreenName:(NSString *)screen_name
//                     AccessToken:(NSString *)access_token
//                    RefreshToken:(NSString *)refresh_token
//                       ExpiresIn:(NSUInteger)expires_in
//                     ReExpiresIn:(NSUInteger)re_expires_in
//                           Block:(void (^)(NSDictionary * dict, NSError * error))block;
+ (void)unbindFromTaobaoWithBlock:(void (^)(BOOL is_remove, NSError * error))block;
//- (GKUserTaobaoToken *)updateBindInfoFromSQLite;
@end
