//
//  GKDBCore.m
//  Grape
//
//  Created by 谢家欣 on 13-4-10.
//  Copyright (c) 2013年 guoku. All rights reserved.
//

#import "GKDBCore.h"
#import "FMDatabase.h"
//#import "FMDatabaseAdditions.h"
#define FMDBQuickCheck(SomeBool) { if (!(SomeBool)) { NSLog(@"Failure on line %d", __LINE__); abort(); } }

@implementation GKDBCore
{
@private
    NSString * _dbpath;
}
@synthesize db = _db;

+ (GKDBCore *)sharedDB;
{
    static GKDBCore * _sharedDB = nil;
    static dispatch_once_t dbOnceToken;

    dispatch_once(&dbOnceToken, ^{
        _sharedDB = [[GKDBCore alloc] init];
    });
    
    return _sharedDB;
}

- (id)init
{
    self = [super init];
    if (self)
    {
        GKLog(@"database path %@", [self dbPath]);
        _db = [FMDatabase databaseWithPath:[self dbPath]];
        [_db open];
    }
    
    return self;
}

- (NSString *)dbPath
{
    NSArray * paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [paths objectAtIndex:0];
    _dbpath = [documentDirectory stringByAppendingPathComponent:kDBFILE];
    return _dbpath;
}

- (BOOL)beginTransaction
{
    return [_db beginTransaction];
}

- (BOOL)commit
{
    return [_db commit];
}

- (BOOL)createTableWithSQL:(NSString *)sql
{
    if (![_db open])
    {
        GKLog(@"%@ databae cant't be opened", kDBFILE);
        return NO;
    }

    FMDBQuickCheck([_db executeUpdate:sql]);
    
    return YES;
}

- (BOOL)createIndexWithSQL:(NSString *)sql
{
    FMDBQuickCheck([_db executeUpdate:sql]);
    return YES;
}

- (BOOL)insertDataWithSQL:(NSString *)sql ArgsDict:(NSDictionary *)argsDict
{
    GKLog(@"%@ %@",sql, argsDict);
    FMDBQuickCheck([_db executeUpdate:sql withParameterDictionary:argsDict]);

    return YES;
}

- (FMResultSet *)queryDataWithSQL:(NSString *)sql
{
    
    FMResultSet * rs = [_db executeQuery:sql];
//    FMDBQuickCheck(rs )
    return rs;
}

//- (FMResultSet *)queryDataWithSQL:(NSString *)sql ArgumentsInArray:(NSArray *)array
//{
//    FMResultSet * rs = [_db executeQuery:sql withArgumentsInArray:array];
//    return rs;
//}

- (FMResultSet *)queryDataWithSQL:(NSString *)sql ArgsDict:(NSDictionary *)argsDict
{
    FMResultSet * rs = [_db executeQuery:sql withParameterDictionary:argsDict];
    return rs;
}

- (BOOL)removeDataWithSQL:(NSString *)sql ArgsDict:(NSDictionary *)argsDict
{
    return [_db executeUpdate:sql withParameterDictionary:argsDict];
}


@end
