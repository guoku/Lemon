//
//  GKUserWeiboToken.m
//  Grape
//
//  Created by 谢家欣 on 13-3-23.
//  Copyright (c) 2013年 guoku. All rights reserved.
//

#import "GKUserWeiboToken.h"
#import "NSDictionary+GKHelp.h"
#import "GKDBCore.h"
#import "GKAppDotNetAPIClient.h"

@implementation GKUserWeiboToken

@synthesize  user_id = _user_id;
@synthesize weibo_id = _weibo_id;
@synthesize access_token = _access_token;
@synthesize screen_name = _screen_name;
@synthesize expires_in = _expires_in;


static NSString * CREATE_WEIBO_TABLE = @"CREATE TABLE IF NOT EXISTS weibo_token \
                                            (id INTEGER PRIMARY KEY NOT NULL, \
                                            user_id INTEGER UNIQUE DEFAULT 0, \
                                            weibo_id UNSIGNED BIG INT, \
                                            access_token varchar(255), \
                                            screen_name varchar(30), \
                                            expires_in INTEGER)";


static NSString * kWeiboInsertSQL = @"REPLACE INTO weibo_token \
                                (user_id, weibo_id, access_token, screen_name, expires_in) \
                                VALUES (:user_id, :weibo_id, :access_token, :screen_name, :expires_in)";

static NSString * REMOVE_WEIBO_SQL = @"DELETE FROM weibo_token WHERE user_id = :user_id";

- (id)initFromSQLiteWithUserID:(NSUInteger)user_id
{
    self = [super init];
    if (!self) {
        return nil;
    }
    
    NSDictionary * argsDict = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%u", user_id], @"user_id", nil];
    NSString * sql = @"SELECT * FROM weibo_token WHERE user_id = :user_id";
    FMResultSet * rs = [[GKDBCore sharedDB] queryDataWithSQL:sql ArgsDict:argsDict];
    
    while ([rs next]) {
        _user_id = [rs intForColumn:@"user_id"];
        _weibo_id = [rs longLongIntForColumn:@"weibo_id"];
        _access_token = [rs stringForColumn:@"access_token"];
        _screen_name = [rs stringForColumn:@"screen_name"];
        _expires_in = [rs intForColumn:@"expires_in"];
        break;
    }
    [rs close];
    return self;
}

- (id)initWithAttributes:(NSDictionary *)attributes
{
    self = [super init];
    if (self)
    {
        _user_id = [[attributes valueForKeyPath:@"user_id"] integerValue];
        _weibo_id = [[attributes valueForKeyPath:@"weibo_id"] longLongValue];
        _access_token = [attributes valueForKeyPath:@"access_token"];
        _screen_name = [attributes valueForKeyPath:@"screen_name"];
        _expires_in = [[attributes valueForKeyPath:@"expires_in"] integerValue];
    }
    
    return self;
}

- (BOOL)createTable
{
    return [[GKDBCore sharedDB] createTableWithSQL:CREATE_WEIBO_TABLE];
//    return YES;
}

- (void)saveToSQLite
{
    [self createTable];
//    NSString * SQL
    if (self.screen_name) {
        NSMutableDictionary * _mutableDict = [NSMutableDictionary dictionaryWithCapacity:5];
        [_mutableDict setValue:[NSString stringWithFormat:@"%u", self.user_id] forKeyPath:@"user_id"];
        [_mutableDict setValue:[NSString stringWithFormat:@"%llu", self.weibo_id] forKeyPath:@"weibo_id"];
        [_mutableDict setValue:self.access_token forKeyPath:@"access_token"];
        [_mutableDict setValue:self.screen_name forKeyPath:@"screen_name"];
        [_mutableDict setValue:[NSString stringWithFormat:@"%u", self.expires_in] forKeyPath:@"expires_in"];
        GKLog(@"weibo token %@", _mutableDict);
        [[GKDBCore sharedDB] insertDataWithSQL:kWeiboInsertSQL ArgsDict:_mutableDict];
    }
}
- (BOOL)removeFromSQLite
{
    NSDictionary * argsDict = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%u", self.user_id], @"user_id", nil];
    return [[GKDBCore sharedDB] removeDataWithSQL:REMOVE_WEIBO_SQL ArgsDict:argsDict];
}

//- (BOOL)removeFromSQILiteWithUserID:(NSUInteger)user_id
//{
//    NSDictionary * argsDict = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%u", user_id], @"user_id", nil];
//    return [[GKDBCore sharedDB] removeDataWithSQL:REMOVE_WEIBO_SQL ArgsDict:argsDict];
//}

+ (void)bindToWeiboWithWeiboID:(unsigned long long)weiboID
                        ScreenName:(NSString *)screen_name
                        AccessToken:(NSString *)access_token
                        ExpiresIn:(NSUInteger)expires_in
                         Block:(void (^)(NSDictionary * dict, NSError * error))block
{
    NSMutableDictionary * paramters = [NSMutableDictionary dictionaryWithCapacity:4];
    [paramters setValue:[NSString stringWithFormat:@"%llu", weiboID] forKey:@"weibo_id"];
    [paramters setValue:screen_name forKey:@"screen_name"];
    [paramters setValue:access_token forKey:@"access_token"];
    [paramters setValue:[NSString stringWithFormat:@"%u", expires_in] forKey:@"expires_in"];
    [[GKAppDotNetAPIClient sharedClient] postPath:@"account/weibo/bind/" parameters:[paramters Paramters] success:^(AFHTTPRequestOperation *operation, id JSON) {
        GKLog(@"%@", JSON);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (block)
        {
            GKLog(@"%@", error);
            block([NSDictionary dictionary], error);
        }
    }];
}

+ (void)unbindFromWeiboWithBlock:(void (^)(BOOL is_remove, NSError * error))block
{
    NSMutableDictionary * paramters = [NSMutableDictionary dictionaryWithCapacity:0];
    [[GKAppDotNetAPIClient sharedClient] postPath:@"account/weibo/unbind/" parameters:[paramters Paramters] success:^(AFHTTPRequestOperation *operation, id JSON) {
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
