//
//  GKEntity.m
//  Grape
//
//  Created by 谢 家欣 on 13-3-27.
//  Copyright (c) 2013年 guoku. All rights reserved.
//

#import "GKEntity.h"
#import "NSDate+GKHelper.h"
#import "JSONKit.h"

static NSString * CREATE_ENTITY_SQL = @"CREATE TABLE IF NOT EXISTS entity \
(id INTEGER PRIMARY KEY NOT NULL, \
entity_id INTEGER NOT NULL, \
pid INTEGER NOT NULL, \
cid INTEGER NOT　NULL, \
title VARCHAR(255), \
brand VARCHAR(255), \
shop VARCHAR(255), \
remark VARCHAR(255), \
pid_list VARCHAR(255), \
image_url VARCHAR(255), \
price REAL, \
avg_score REAL, \
liked_count INTEGER DEFAULT 0, \
used_count INTEGER DEFAULT 0, \
my_score INTEGER DEFAULT 0, \
weight INTEGER DEFAULT 0)";


static NSString * CREATE_ENTITY_INDEX = @"CREATE UNIQUE INDEX IF NOT EXISTS entity_pid_index ON entity (entity_id, pid)";


static NSString * INSERT_DATA_SQL = @"REPLACE INTO entity (entity_id,pid ,cid ,title, brand, image_url, price, avg_score,liked_count, used_count, weight,shop,remark,my_score,pid_list) VALUES(:entity_id,:pid ,:cid ,:title, :brand, :image_url, :price, :avg_score,:liked_count, :used_count, :weight,:shop,:remark,:my_score,:pid_list)";

static NSString * GET_MOST_IMPORTANT_QUERY_SQL = @"SELECT * FROM entity ORDER BY weight DESC LIMIT 30;";
static NSString * GET_ENTITY_BY_PID_QUERY_SQL = @"SELECT * FROM entity WHERE pid = :pid ORDER BY cid";
static NSString * DELETE_ENTITY_SQL = @"DELETE FROM entity WHERE entity_id = :entity_id";
static NSString * GET_ENTITY_COUNT_GROUP_BY_PID_QUERY_SQL = @"SELECT count(*) AS count,pid FROM entity GROUP BY pid";


@implementation GKEntity {
@private
    NSString * _imgUrlString;
    NSMutableArray * _shopList;
}

@synthesize entity_id = _entity_id;
@synthesize pid = _pid;
@synthesize brand = _brand;
@synthesize remark_list = _remark_list;
@synthesize avg_score = _avg_score;
@synthesize purchase_list = _purchase_list;
@synthesize pid_list = _pid_list;
@synthesize cid = _cid;
@synthesize title = _title;
@synthesize used_count = _used_count;
@synthesize liked_count = _liked_count;
@synthesize price = _price;
@synthesize entitylike = _entitylike;
@synthesize weight = _weight;
@synthesize my_score = _my_score;

- (id)initWithAttributes:(NSDictionary *)attributes
{
    self = [super init];
    if (self)
    {
        _entity_id = [[attributes valueForKeyPath:@"entity_id"] integerValue];
        _pid = [[attributes valueForKeyPath:@"selected_phase_id"] intValue];
        _brand = [attributes valueForKeyPath:@"brand"];
        _remark_list = [NSMutableArray arrayWithArray:[attributes valueForKey:@"remark_list"]];
        _pid_list = [NSMutableArray arrayWithArray:[attributes valueForKey:@"phase_id_list"]];
        _cid = [[attributes valueForKeyPath:@"category_id"] intValue];
        _title = [attributes valueForKeyPath:@"title"];
        _imgUrlString = [attributes valueForKeyPath:@"image_url"];
        _used_count = [[attributes valueForKeyPath:@"used_count"] integerValue];
        _liked_count = [[attributes valueForKeyPath:@"liked_count"] integerValue];
        if([attributes valueForKeyPath:@"my_score"])
        {
        _my_score = [[attributes valueForKeyPath:@"my_score"]integerValue];
        }
        else
        {
            _my_score = 11;
        }
        _avg_score = [[attributes valueForKeyPath:@"avg_score"]integerValue];
        _weight = 0;
        
        //BOOL _like_status = [[[attributes valueForKeyPath:@"entity_like"] valueForKeyPath:@"status"] boolValue];
        //if (_like_status){
        //    GKLog(@"entity_like ---------- %@", [attributes valueForKeyPath:@"entity_like"]);
        //    _entitylike = [[GKEntityLike alloc] initWithAttributes:[attributes valueForKeyPath:@"entity_like"]];
        //}
        BOOL _like_status = [[attributes valueForKeyPath:@"liked_already"]boolValue];
        if(_like_status)
        {
            NSMutableDictionary * a = [[NSMutableDictionary alloc]initWithObjectsAndKeys:[attributes valueForKeyPath:@"entity_id"],@"entity_id",@"YES",@"status",nil];
            _entitylike = [[GKEntityLike alloc] initWithAttributes:a];
            [_entitylike saveToSQLite];
        }
        
        _shopList = [attributes valueForKey:@"purchase_list"];
        _purchase_list = [NSMutableArray arrayWithCapacity:[[attributes valueForKey:@"purchase_list"] count]];
        _price = CGFLOAT_MAX;
        for (NSDictionary * noteAttribute in _shopList)
        {
            GKShop * _shop = [[GKShop alloc] initWithAttributes:noteAttribute];
            [_purchase_list addObject:_shop];
            if(_price >_shop.price)
            {
                _price = _shop.price;
            }
        }
    }
    return self;
}
- (id)initFromSQLiteWithRsSet:(FMResultSet *)rs
{
    self = [super init];
    if (self)
    {
        _entity_id = [rs intForColumn:@"entity_id"];
        _pid = [rs intForColumn:@"pid"];
        _cid = [rs intForColumn:@"cid"];
        _title = [rs stringForColumn:@"title"];
        _brand = [rs stringForColumn:@"brand"];
        _imgUrlString = [rs stringForColumn:@"image_url"];
        _price = [rs doubleForColumn:@"price"];
        _liked_count = [rs intForColumn:@"liked_count"];
        _used_count = [rs intForColumn:@"used_count"];
        _my_score = [rs intForColumn:@"my_score"];
        _shopList = [[rs stringForColumn:@"shop"]objectFromJSONString];
        _pid_list = [[rs stringForColumn:@"pid_list"]objectFromJSONString];
        _purchase_list = [NSMutableArray arrayWithCapacity:[_shopList count]];
        for (NSDictionary * noteAttribute in _shopList)
        {
            GKShop * _shop = [[GKShop alloc] initWithAttributes:noteAttribute];
            [_purchase_list addObject:_shop];
        }
        _remark_list = [[rs stringForColumn:@"remark"]objectFromJSONString];
        _weight = [rs intForColumn:@"weight"];
        _entitylike = [GKEntityLike getEntityLikeStatusFromSQLiteWithEntityID:_entity_id];
    }
    
    return self;
}
- (NSURL *)imageURL {
    return [NSURL URLWithString:_imgUrlString];
}
- (BOOL)createTable
{
    if ([[GKDBCore sharedDB] createTableWithSQL:CREATE_ENTITY_SQL])
    {
        return [[GKDBCore sharedDB] createTableWithSQL:CREATE_ENTITY_INDEX];
    }
    
    return NO;
}
- (GKEntity *)save
{
    if ([self createTable])
    {
        NSMutableDictionary * argsDict = [NSMutableDictionary dictionaryWithCapacity:13];
        [argsDict setValue:[NSString stringWithFormat:@"%u", _entity_id] forKey:@"entity_id"];
        [argsDict setValue:[NSString stringWithFormat:@"%u", _pid] forKey:@"pid"];
        [argsDict setValue:[NSString stringWithFormat:@"%u", _cid] forKey:@"cid"];
        [argsDict setValue:_title forKey:@"title"];
        [argsDict setValue:_brand forKey:@"brand"];
        [argsDict setValue:_imgUrlString forKey:@"image_url"];
        [argsDict setValue:[NSString stringWithFormat:@"%.2f", _avg_score] forKey:@"avg_score"];
        [argsDict setValue:[NSString stringWithFormat:@"%.2f", _price] forKey:@"price"];
        [argsDict setValue:[NSString stringWithFormat:@"%u", _liked_count] forKey:@"liked_count"];
        [argsDict setValue:[NSString stringWithFormat:@"%u", _used_count] forKey:@"used_count"];
        [argsDict setValue:[NSString stringWithFormat:@"%u", _my_score] forKey:@"my_score"];
        [argsDict setValue:[NSString stringWithFormat:@"%u", _weight] forKey:@"weight"];
        [argsDict setValue:[_shopList JSONString] forKey:@"shop"];
        [argsDict setValue:[_remark_list JSONString] forKey:@"remark"];
        [argsDict setValue:[_pid_list JSONString] forKey:@"pid_list"];
    
        if ([[GKDBCore sharedDB] insertDataWithSQL:INSERT_DATA_SQL ArgsDict:argsDict])
        {
            [_entitylike saveToSQLite];
        }
    }
    return self;
}
+ (NSArray *)getEntityCountGroupByPid
{
    FMResultSet * rs = [[GKDBCore sharedDB] queryDataWithSQL:GET_ENTITY_COUNT_GROUP_BY_PID_QUERY_SQL];
    NSMutableArray * _mutableArray = [NSMutableArray arrayWithCapacity:0];
    while ([rs next]) {
        [_mutableArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:@([rs intForColumn:@"count"]),@"count",@([rs intForColumn:@"pid"]),@"pid",nil]];
    }
    return [NSArray arrayWithArray:_mutableArray];
}
+ (NSArray *)getNeedResquestEntity
{
    FMResultSet * rs = [[GKDBCore sharedDB] queryDataWithSQL:GET_MOST_IMPORTANT_QUERY_SQL];
    NSLog(@"%@",rs);
    NSMutableArray * _mutableArray = [NSMutableArray arrayWithCapacity:0];
    while ([rs next]) {
        //[_mutableArray addObject:[NSString stringWithFormat:@"%u",[rs intForColumn:@"entity_id"]]];
        [_mutableArray addObject:[[GKEntity alloc] initFromSQLiteWithRsSet:rs]];
    }
    return [NSArray arrayWithArray:_mutableArray];
}
+ (NSArray *)getEntityWithPid:(NSUInteger)pid
{
    NSMutableDictionary * argsDict = [NSMutableDictionary dictionaryWithCapacity:13];
    [argsDict setValue:[NSString stringWithFormat:@"%u", pid] forKey:@"pid"];
    FMResultSet * rs = [[GKDBCore sharedDB] queryDataWithSQL:GET_ENTITY_BY_PID_QUERY_SQL ArgsDict:argsDict];
    NSMutableArray * _mutableArray = [NSMutableArray arrayWithCapacity:0];
    while ([rs next]) {
        [_mutableArray addObject:[[GKEntity alloc] initFromSQLiteWithRsSet:rs]];
    }
    return [NSArray arrayWithArray:_mutableArray];
}
+ (BOOL)deleteWithEntityID:(NSUInteger)entity_id
{
    NSDictionary * argsDict = [NSDictionary dictionaryWithObjectsAndKeys:
                               [NSString stringWithFormat:@"%u", entity_id], @"entity_id",nil];
    
    return [[GKDBCore sharedDB] removeDataWithSQL:DELETE_ENTITY_SQL ArgsDict:argsDict];
}

@end
