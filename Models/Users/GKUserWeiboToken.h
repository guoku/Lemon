//
//  GKUserWeiboToken.h
//  Grape
//
//  Created by 谢家欣 on 13-3-23.
//  Copyright (c) 2013年 guoku. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GKUserWeiboToken : NSObject

@property (nonatomic, assign) NSUInteger user_id;
@property (nonatomic, assign) unsigned long long weibo_id;
@property (nonatomic, strong) NSString * access_token;
@property (nonatomic, strong) NSString * screen_name;
@property (nonatomic, assign) NSUInteger expires_in;

- (id)initFromSQLiteWithUserID:(NSUInteger)user_id;
- (id)initWithAttributes:(NSDictionary *)attributes;
- (void)saveToSQLite;
- (BOOL)removeFromSQLite;

+ (void)bindToWeiboWithWeiboID:(unsigned long long)weiboID
                    ScreenName:(NSString *)screen_name
                    AccessToken:(NSString *)access_token
                     ExpiresIn:(NSUInteger)expires_in
                         Block:(void (^)(NSDictionary * dict, NSError * error))block;
+ (void)unbindFromWeiboWithBlock:(void (^)(BOOL is_remove, NSError * error))block;
@end
