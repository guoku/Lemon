//
//  GKEntityLike.m
//  Grape
//
//  Created by 谢 家欣 on 13-3-27.
//  Copyright (c) 2013年 guoku. All rights reserved.
//

#import "GKEntityLike.h"
#import "GKAppDotNetAPIClient.h"

#import "NSDictionary+GKHelp.h"
#import "NSDate+GKHelper.h"


static NSString * CREATE_ENTITY_LIKE_SQL = @"CREATE TABLE IF NOT EXISTS entity_like \
                                ( id INTEGER PRIMARY KEY NOT NULL, \
                                entity_id INTEGER, \
                                user_id INTEGER, \
                                liked_time timestamp, \
                                status BOOLEAN )";

static NSString * CREATE_ENTITY_LIKE_INDEX = @"CREATE UNIQUE INDEX IF NOT EXISTS entity_like_index ON entity_like (entity_id, user_id)";

static NSString * INSERT_ENTITY_LIKE_SQL = @"REPLACE INTO entity_like (entity_id, user_id, liked_time, status) VALUES (:entity_id, :user_id, :liked_time, :status)";

static NSString * DELETE_ENTITY_LIKE_SQL = @"DELETE FROM entity_like WHERE entity_id = :entity_id and user_id = :user_id";

static NSString * DELETE_ALL_ENTITY_LIKE_SQL = @"DELETE FROM entity_like";

static NSString * QUERY_ENTITY_LIKE_SQL = @"SELECT * FROM entity_like WHERE entity_id = :entity_id";

@implementation GKEntityLike

@synthesize entity_id = _entity_id;
@synthesize user_id = _user_id;
@synthesize liked_time = _liked_time;
@synthesize status = _status;


- (id)initFromSQLiteWithFMResultSet:(FMResultSet *)rs
{
    self = [super init];
    if (self)
    {
        _entity_id = [rs intForColumn:@"entity_id"];
        _user_id = [rs intForColumn:@"user_id"];
        _liked_time = [NSDate dateFromString:[rs stringForColumn:@"liked_time"]];
        _status = [rs boolForColumn:@"status"];
    }
    
    return self;
}

- (id)initWithAttributes:(NSDictionary *)attributes
{
    self = [super init];
    if (self)
    {
        _entity_id = [[attributes valueForKeyPath:@"entity_id"] integerValue];
        _user_id = [[attributes valueForKeyPath:@"user_id"] integerValue];
        _liked_time = [NSDate dateFromString:[attributes valueForKeyPath:@"liked_time"]];
        _status = [[attributes valueForKeyPath:@"status"] boolValue];
    }
    
    return self;
}

+ (BOOL)createTableAndIndex
{
    if ([[GKDBCore sharedDB] createTableWithSQL:CREATE_ENTITY_LIKE_SQL])
    {
        return [[GKDBCore sharedDB] createTableWithSQL:CREATE_ENTITY_LIKE_INDEX];
    }
    return NO;
}

+ (void)DeleteAllData
{
    [[GKDBCore sharedDB] removeDataWithSQL:DELETE_ALL_ENTITY_LIKE_SQL ArgsDict:nil];
}

- (BOOL)createTABLE
{
    if ([[GKDBCore sharedDB] createTableWithSQL:CREATE_ENTITY_LIKE_SQL])
    {
        return [[GKDBCore sharedDB] createTableWithSQL:CREATE_ENTITY_LIKE_INDEX];
//        NSMutableDictionary * argsDict = [NSMutableDictionary dictionaryWithCapacity:4];
//        [argsDict setValue:[NSNumber numberWithInt:_entity_id] forKey:@"entity_id"];
//        [argsDict setValue:[NSNumber numberWithInt:_user_id] forKey:@"user_id"];
//        [argsDict setValue:[NSDate stringFromDate:_liked_time] forKey:@"liked_time"];
//        [argsDict setValue:[NSNumber numberWithBool:_status] forKey:@"status"];
//        return [[GKDBCore sharedDB] insertDataWithSQL:INSERT_ENTITY_LIKE_SQL ArgsDict:argsDict];
    }
    
    return NO;
}

- (BOOL)saveToSQLite
{
    if ([self createTABLE])
    {
        NSMutableDictionary * argsDict = [NSMutableDictionary dictionaryWithCapacity:4];
        [argsDict setValue:[NSString stringWithFormat:@"%u", _entity_id] forKey:@"entity_id"];
        [argsDict setValue:[NSString stringWithFormat:@"%u", _user_id] forKey:@"user_id"];
        [argsDict setValue:[NSDate stringFromDate:_liked_time] forKey:@"liked_time"];
        [argsDict setValue:[NSString stringWithFormat:@"%d", _status] forKey:@"status"];
        GKLog(@"%@", argsDict);
        return [[GKDBCore sharedDB] insertDataWithSQL:INSERT_ENTITY_LIKE_SQL ArgsDict:argsDict];
    }
    return NO;
}

- (BOOL)deleteWithEntityID:(NSUInteger)entity_id UserID:(NSUInteger)user_id
{
    NSDictionary * argsDict = [NSDictionary dictionaryWithObjectsAndKeys:
                               [NSString stringWithFormat:@"%u", entity_id], @"entity_id",
                               [NSString stringWithFormat:@"%u", user_id], @"user_id", nil];
    
    return [[GKDBCore sharedDB] removeDataWithSQL:DELETE_ENTITY_LIKE_SQL ArgsDict:argsDict];
//    return YES;
}


+ (GKEntityLike *)getEntityLikeStatusFromSQLiteWithEntityID:(NSUInteger)entity_id
{
    NSDictionary * argsDict = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:entity_id], @"entity_id", nil];
    FMResultSet * rs = [[GKDBCore sharedDB] queryDataWithSQL:QUERY_ENTITY_LIKE_SQL ArgsDict:argsDict];
    GKEntityLike * entity_like = nil;
    while ([rs next]) {
        entity_like = [[GKEntityLike alloc] initFromSQLiteWithFMResultSet:rs];
    }
    [rs close];
    return entity_like;
}

+ (void)changeLikeActionWithEntityID:(NSUInteger)entity_id
                            Selected:(BOOL)selected
                               Block:(void (^)(NSDictionary *dict, NSError * error))block
{
    NSMutableDictionary * paramters = [NSMutableDictionary dictionaryWithCapacity:4];
    [paramters setValue:[NSString stringWithFormat:@"%u", entity_id] forKeyPath:@"eid"];

    

    [[GKAppDotNetAPIClient sharedClient] getPath:[NSString stringWithFormat:@"maria/entity/81931/like/%d",selected] parameters:[paramters Paramters] success:^(AFHTTPRequestOperation *operation, id JSON) {

        NSUInteger  res_code = [[JSON valueForKeyPath:@"res_code"] integerValue];
        NSError * aError;
        GKLog(@"%@", JSON);
        switch (res_code) {
            case SUCCESS:
            {
                
                NSArray * entitylikeResponse = [[JSON valueForKeyPath:@"results"] valueForKeyPath:@"data"];
                NSMutableDictionary * mutalbleDict = [NSMutableDictionary dictionaryWithCapacity:1];
                for (NSDictionary *attributes in entitylikeResponse)
                {
                    GKEntityLike * entityLike = [[GKEntityLike alloc] initWithAttributes:attributes];
                    if (entityLike.status) {
                        [entityLike saveToSQLite];
                    } else
                    {
                        [entityLike deleteWithEntityID:entityLike.entity_id UserID:entityLike.user_id];
                    }
                    [mutalbleDict setValue:entityLike forKeyPath:@"content"];
                }
                
                if (block)
                {
                    block([NSDictionary dictionaryWithDictionary:mutalbleDict], nil);
                }
            }
                break;
            case SESSION_ERROR:
            {
                NSString * errorMsg = [JSON valueForKeyPath:@"res_msg"];
                NSDictionary * userInfo = [NSDictionary dictionaryWithObject:errorMsg forKey:NSLocalizedDescriptionKey];
                aError = [NSError errorWithDomain:UserErrorDomain code:kUserSessionError userInfo:userInfo];
            }
                break;
            default:
                break;
        }
        
     if (res_code != SUCCESS)
     {
         if (block)
         {
             block([NSDictionary dictionary], aError);
         }
     }

        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (block)
        {
            GKLog(@"%@", error);
            block([NSDictionary dictionary], error);
        }
    }];
    
}

@end
