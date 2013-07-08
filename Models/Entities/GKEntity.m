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
entity_id INTEGER UNIQUE NOT NULL, \
pid INTEGER, \
cid INTEGER, \
title VARCHAR(255), \
brand VARCHAR(255), \
shop VARCHAR(255), \
remark VARCHAR(255), \
image_url VARCHAR(255), \
price REAL, \
avg_score REAL, \
liked_count INTEGER DEFAULT 0, \
used_count INTEGER DEFAULT 0, \
weight INTEGER DEFAULT 0)";

static NSString * INSERT_DATA_SQL = @"REPLACE INTO entity (entity_id,pid ,cid ,title, brand, image_url, price, avg_score,liked_count, used_count, weight,shop,remark) VALUES(:entity_id,:pid ,:cid ,:title, :brand, :image_url, :price, :avg_score,:liked_count, :used_count, :weight,:shop,:remark)";

//static NSString * GET_MOST_IMPORTANT_QUERY_SQL = @"SELECT entity_id FROM entity LIMIT 30 \
ORDER BY weight DESC;";
static NSString * GET_MOST_IMPORTANT_QUERY_SQL = @"SELECT * FROM entity ORDER BY weight DESC LIMIT 30;";


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
@synthesize cid = _cid;
@synthesize title = _title;
@synthesize used_count = _used_count;
@synthesize liked_count = _liked_count;
@synthesize price = _price;
@synthesize entitylike = _entitylike;
@synthesize weight = _weight;

- (id)initWithAttributes:(NSDictionary *)attributes
{
    self = [super init];
    if (self)
    {
        _entity_id = [[attributes valueForKeyPath:@"entity_id"] integerValue];
        _pid = [[attributes valueForKeyPath:@"pid"] intValue];
        _brand = [attributes valueForKeyPath:@"brand"];
        
        _remark_list = [NSMutableArray arrayWithCapacity:[[attributes valueForKey:@"remark_list"] count]];
        for (NSString * remark in [attributes valueForKey:@"remark_list"])
        {
            [_remark_list addObject:remark];
        }
        
        _cid = [[attributes valueForKeyPath:@"cid"] intValue];
        _title = [attributes valueForKeyPath:@"title"];
        _imgUrlString = [attributes valueForKeyPath:@"image_url"];
        _used_count = [[attributes valueForKeyPath:@"used_count"] integerValue];
        _liked_count = [[attributes valueForKeyPath:@"liked_count"] integerValue];
        _price = [[attributes valueForKey:@"price"] floatValue];
        _weight = 0;
        
        BOOL _like_status = [[[attributes valueForKeyPath:@"entity_like"] valueForKeyPath:@"status"] boolValue];
        if (_like_status){
            GKLog(@"entity_like ---------- %@", [attributes valueForKeyPath:@"entity_like"]);
            _entitylike = [[GKEntityLike alloc] initWithAttributes:[attributes valueForKeyPath:@"entity_like"]];
        }
        _shopList = [attributes valueForKey:@"purchase_list"];
        _purchase_list = [NSMutableArray arrayWithCapacity:[[attributes valueForKey:@"purchase_list"] count]];
        for (NSDictionary * noteAttribute in _shopList)
        {
            GKShop * _shop = [[GKShop alloc] initWithAttributes:noteAttribute];
            [_purchase_list addObject:_shop];
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
        _shopList = [[rs stringForColumn:@"shop"]objectFromJSONString];
        _purchase_list = [NSMutableArray arrayWithCapacity:[_shopList count]];
        for (NSDictionary * noteAttribute in _shopList)
        {
            GKShop * _shop = [[GKShop alloc] initWithAttributes:noteAttribute];
            [_purchase_list addObject:_shop];
        }
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
    return [[GKDBCore sharedDB] createTableWithSQL:CREATE_ENTITY_SQL];
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
        [argsDict setValue:[NSString stringWithFormat:@"%u", _weight] forKey:@"weight"];
        [argsDict setValue:[_shopList JSONString] forKey:@"shop"];
        [argsDict setValue:[_remark_list JSONString] forKey:@"remark"];
    
        if ([[GKDBCore sharedDB] insertDataWithSQL:INSERT_DATA_SQL ArgsDict:argsDict])
        {
            [_entitylike saveToSQLite];
        }
    }
    return self;
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

@end
