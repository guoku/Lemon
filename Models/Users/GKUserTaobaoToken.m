//
//  GKUserTaobaoToken.m
//  Grape
//
//  Created by 谢家欣 on 13-3-23.
//  Copyright (c) 2013年 guoku. All rights reserved.
//

#import "GKUserTaobaoToken.h"
#import "GKDBCore.h"
#import "GKAppDotNetAPIClient.h"
#import "NSDictionary+GKHelp.h"

@implementation GKUserTaobaoToken

@synthesize user_id = _user_id;
@synthesize taobao_id = _taobao_id;
@synthesize screen_name = _screen_name;
@synthesize access_token = _access_token;
@synthesize expires_in = _expires_in;
@synthesize re_expires_in = _re_expires_in;

static NSString * kTaobaoInsertSQL = @"REPLACE INTO taobao_token \
                            (user_id, taobao_id, access_token, screen_name, expires_in, re_expires_in) \
                            VALUES (:user_id, :taobao_id, :access_token, :screen_name, :expires_in, :re_expires_in)";

static NSString * REMOVE_TAOBAO_SQL = @"DELETE FROM taobao_token WHERE user_id = :user_id";

- (id)initFromSQLiteWithUserID:(NSUInteger)user_id
{
    self = [super init];
    if (!self)
    {
        return nil;
    }
    NSDictionary * _argsDict = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%u", user_id], @"user_id", nil];
    NSString * sql = @"SELECT * FROM taobao_token WHERE user_id = :user_id";
    FMResultSet * rs = [[GKDBCore sharedDB] queryDataWithSQL:sql ArgsDict:_argsDict];
    while ([rs next]) {
        _user_id = [rs intForColumn:@"user_id"];
        _taobao_id = [[rs stringForColumn:@"taobao_id"] longLongValue];
        _screen_name = [rs stringForColumn:@"screen_name"];
        _access_token = [rs stringForColumn:@"access_token"];
        _expires_in = [rs intForColumn:@"expires_in"];
        _re_expires_in = [rs intForColumn:@"re_expires_in"];
        break;
    }
    [rs close];
    return self;
}


- (id)initWithAttributes:(NSDictionary *)attributes
{
    if (!attributes) {
        return  nil;
    }
    self = [super init];
//    GKLog(@"taobao token %@", attributes);
    if (self) {
        _user_id = [[attributes valueForKeyPath:@"user_id"] integerValue];
        _taobao_id = [[attributes valueForKeyPath:@"taobao_id"] longLongValue];
        _screen_name = [attributes valueForKeyPath:@"screen_name"];
        _access_token = [attributes valueForKeyPath:@"access_token"];
        _expires_in = [[attributes valueForKeyPath:@"expires_in"] integerValue];
        _re_expires_in = [[attributes valueForKeyPath:@"re_expires_in"] integerValue];
    }
    
    return self;
}

- (BOOL)createTable
{
    return [[GKDBCore sharedDB] createTableWithSQL:@"CREATE TABLE IF NOT EXISTS taobao_token \
            (id INTEGER PRIMARY KEY NOT NULL, \
            user_id INTEGER UNIQUE DEFAULT 0, \
            taobao_id UNSIGNED BIG INT, \
            access_token varchar(255), \
            screen_name varchar(30), \
            expires_in INTEGER, \
            re_expires_in INTEGER)"];
    //    return YES;
}

- (void)saveToSQLite
{
    [self createTable];
//    GKLog(@"okokokokoko");
    if (self.screen_name)
    {
        NSMutableDictionary * _mutableDict = [NSMutableDictionary dictionaryWithCapacity:6];
        [_mutableDict setValue:[NSString stringWithFormat:@"%u", self.user_id] forKeyPath:@"user_id"];
        [_mutableDict setValue:[NSString stringWithFormat:@"%llu", self.taobao_id] forKeyPath:@"taobao_id"];
        [_mutableDict setValue:self.access_token forKeyPath:@"access_token"];
        [_mutableDict setValue:self.screen_name forKeyPath:@"screen_name"];
        [_mutableDict setValue:[NSString stringWithFormat:@"%u", self.expires_in] forKeyPath:@"expires_in"];
        [_mutableDict setValue:[NSString stringWithFormat:@"%u", self.re_expires_in] forKeyPath:@"re_expires_in"];
        GKLog(@"save save %@", _mutableDict);
        [[GKDBCore sharedDB] insertDataWithSQL:kTaobaoInsertSQL ArgsDict:_mutableDict];
    }
}

- (BOOL)removeFromSQLite
{
    NSDictionary * argsDict = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%u", self.user_id], @"user_id", nil];
    
    return [[GKDBCore sharedDB] removeDataWithSQL:REMOVE_TAOBAO_SQL ArgsDict:argsDict];
}

//- (BOOL)removeFromSQLiteWithUserID:(NSUInteger)user_id
//{
//    NSDictionary * argsDict = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%u", user_id], @"user_id", nil];
//    
//    return [[GKDBCore sharedDB] removeDataWithSQL:REMOVE_TAOBAO_SQL ArgsDict:argsDict];
//}

//+ (void)bindToTaobaoWithTaobaoID:(unsigned long long)taobao_id
//                    ScreenName:(NSString *)screen_name
//                   AccessToken:(NSString *)access_token
//                   RefreshToken:(NSString *)refresh_token
//                     ExpiresIn:(NSUInteger)expires_in
//                   ReExpiresIn:(NSUInteger)re_expires_in
//                         Block:(void (^)(NSDictionary * dict, NSError * error))block
//{
//    NSMutableDictionary * paramters = [NSMutableDictionary dictionaryWithCapacity:4];
//    [paramters setValue:[NSString stringWithFormat:@"%llu", taobao_id] forKey:@"taobao_id"];
//    [paramters setValue:screen_name forKey:@"screen_name"];
//    [paramters setValue:access_token forKey:@"access_token"];
//    [paramters setValue:refresh_token forKey:@"refresh_token"];
//    [paramters setValue:[NSString stringWithFormat:@"%u", expires_in] forKey:@"expires_in"];
//    [paramters setValue:[NSString stringWithFormat:@"%u", re_expires_in] forKey:@"re_expires_in"];
//    [[GKAppDotNetAPIClient sharedClient] postPath:@"account/taobao/bind/" parameters:[paramters Paramters] success:^(AFHTTPRequestOperation *operation, id JSON) {
//        GKLog(@"%@", JSON);
//        
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        if (block)
//        {
//            GKLog(@"%@", error);
//            block([NSDictionary dictionary], error);
//        }
//    }];
//}

+ (void)unbindFromTaobaoWithBlock:(void (^)(BOOL is_remove, NSError * error))block
{
    NSMutableDictionary * paramters = [NSMutableDictionary dictionaryWithCapacity:0];
    [[GKAppDotNetAPIClient sharedClient] postPath:@"account/taobao/unbind/" parameters:[paramters Paramters] success:^(AFHTTPRequestOperation *operation, id JSON) {
        GKLog(@"response %@", JSON);
        NSUInteger res_code = [[JSON valueForKeyPath:@"res_code"] integerValue];
        switch (res_code) {
            case SUCCESS:
            {
                if (block)
                {
                    block(YES, nil);
                }
            }
                break;
                
            default:
                break;
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (block)
        {
            block(NO, error);
        }
    }];
}

@end
