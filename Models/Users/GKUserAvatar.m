//
//  GKUserAvatar.m
//  Grape
//
//  Created by 谢家欣 on 13-3-23.
//  Copyright (c) 2013年 guoku. All rights reserved.
//

#import "GKUserAvatar.h"
#import "GKDBCore.h"


static  NSString * CREATE_AVATAR_TABLE_SQL = @"CREATE TABLE IF NOT EXISTS user_avatar \
                                        (id INTEGER PRIMARY KEY NOT NULL, \
                                        user_id INTEGER, \
                                        avatar_origin_name VARCHAR(255), \
                                        avatar_small_name VARCHAR(255), \
                                        avatar_large_name VARCHAR(255))";

static NSString * REMOVE_AVATAR_SQL = @"DELETE FROM user_avatar WHERE user_id = :user_id";

@implementation GKUserAvatar {
@private
    NSString * _avatarOriginURLString;
    NSString * _avatarSmallURLString;
    NSString * _avatarLargeURLString;
}

@synthesize user_id = _user_id;

- (id)initFromSQLiteWithUserID:(NSUInteger)user_id
{

    self = [super init];
    
    if (!self)
    {
        return nil;
    }
    NSDictionary * argsDict = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%u", user_id], @"user_id", nil];
    NSString * sql = @"SELECT * FROM user_avatar WHERE user_id = :user_id";
//    FMResultSet * rs = [[GKDBCore sharedDB] queryDataWithSQL:@""]
    FMResultSet * rs = [[GKDBCore sharedDB] queryDataWithSQL:sql ArgsDict:argsDict];
    while ([rs next]) {
        _user_id = [rs intForColumn:@"user_id"];
        _avatarOriginURLString = [rs stringForColumn:@"avatar_origin_name"];
        _avatarSmallURLString = [rs stringForColumn:@"avatar_small_name"];
        _avatarLargeURLString = [rs stringForColumn:@"avatar_large_name"];
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
        _avatarOriginURLString = [attributes valueForKeyPath:@"avatar_origin_name"];
        _avatarSmallURLString = [attributes valueForKeyPath:@"avatar_small_name"];
        _avatarLargeURLString = [attributes valueForKeyPath:@"avatar_large_name"];
    }
    return self;
}

- (NSURL *)avatarOriginURL
{
    return [NSURL URLWithString:_avatarOriginURLString];
}

- (NSURL *)avatarSmallURL
{
    return [NSURL URLWithString:_avatarSmallURLString];
}

- (NSURL *)avatarLargeURL
{
    return [NSURL URLWithString:_avatarLargeURLString];
}

- (BOOL)createTable
{
    return [[GKDBCore sharedDB] createTableWithSQL:CREATE_AVATAR_TABLE_SQL];
}

- (BOOL)saveToSQLite
{
    if (![self createTable])
    {
        return NO;
    }
    
    NSString * sql = @"REPLACE INTO user_avatar (user_id, avatar_origin_name, avatar_small_name, avatar_large_name) VALUES (:user_id, :avatar_origin_name, :avatar_small_name, :avatar_large_name)";
//    return NO;
    NSMutableDictionary * _argsDict = [NSMutableDictionary dictionaryWithCapacity:4];
    [_argsDict setValue:[NSString stringWithFormat:@"%u", self.user_id] forKey:@"user_id"];
    [_argsDict setValue:_avatarOriginURLString forKey:@"avatar_origin_name"];
    [_argsDict setValue:_avatarSmallURLString forKey:@"avatar_small_name"];
    [_argsDict setValue:_avatarLargeURLString forKey:@"avatar_large_name"];
    
    return [[GKDBCore sharedDB] insertDataWithSQL:sql ArgsDict:_argsDict];
}

- (BOOL)removeFromSQLiteWithUserID:(NSUInteger)user_id
{
    NSDictionary * argsDict = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%u", user_id], @"user_id", nil];
    return [[GKDBCore sharedDB] removeDataWithSQL:REMOVE_AVATAR_SQL ArgsDict:argsDict];
}

@end
