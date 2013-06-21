//
//  GKEntity.m
//  Grape
//
//  Created by 谢 家欣 on 13-3-27.
//  Copyright (c) 2013年 guoku. All rights reserved.
//

#import "GKEntity.h"
#import "NSDate+GKHelper.h"

static NSString * CREATE_ENTITY_SQL = @"CREATE TABLE IF NOT EXISTS entity \
                                    (id INTEGER PRIMARY KEY NOT NULL, \
                                    entity_id INTEGER UNIQUE NOT NULL, \
                                    taobao_id VARCHAR(50), \
                                    entity_hash CHAR(8), \
                                    title VARCHAR(255), \
                                    url VARCHAR(255), \
                                    image_url VARCHAR(255), \
                                    brand VARCHAR(255), \
                                    stuff_status VARCHAR(255), \
                                    price REAL, \
                                    category_id INTEGER, \
                                    liked_count INTEGER DEFAULT 0, \
                                    popularity INTEGER DEFAULT 0, \
                                    created_time timestamp)";

static NSString * INSERT_DATA_SQL = @"REPLACE INTO entity (entity_id, taobao_id, entity_hash, title, url, image_url, brand, stuff_status, price, category_id, liked_count, popularity, created_time) VALUES (:entity_id, :taobao_id, :entity_hash, :title, :url, :image_url, :brand, :stuff_status, :price, :category_id, :liked_count, :popularity, :created_time)";

//static NSString * QUERY_SQL = @"SELECT * FROM entity WHERE created_time = :created_time limit :limit";


@implementation GKEntity {
@private
    NSString * _imgUrlString;
}

@synthesize entity_id = _entity_id;
@synthesize taobao_id = _taobao_id;
@synthesize entity_hash = _entity_hash;
@synthesize title = _title;
@synthesize urlString = _urlString;
@synthesize brand = _brand;
@synthesize stuff_status = _stuff_status;
@synthesize price = _price;
@synthesize category_id = _category_id;
@synthesize liked_count = _liked_count;
@synthesize notes_list = _notes_list;
@synthesize created_time = _created_time;
@synthesize popularity = _popularity;
@synthesize entitylike = _entitylike;

- (id)initFromSQLiteWithRsSet:(FMResultSet *)rs
{
    self = [super init];
    if (self)
    {
        _entity_id = [rs intForColumn:@"entity_id"];
        _taobao_id = [rs stringForColumn:@"taobao_id"];
        _entity_hash = [rs stringForColumn:@"entity_hash"];
        _title = [rs stringForColumn:@"title"];
        _brand = [rs stringForColumn:@"brand"];
        _urlString = [rs stringForColumn:@"url"];
        _imgUrlString = [rs stringForColumn:@"image_url"];
        _stuff_status = [rs stringForColumn:@"stuff_status"];
        _price = [rs doubleForColumn:@"price"];
        _category_id = [rs intForColumn:@"category_id"];
        _liked_count = [rs intForColumn:@"liked_count"];
        _created_time = [NSDate dateFromString:[rs stringForColumn:@"created_time"]];
//        GKLog(@"time time %@", _created_time);
        _popularity = [rs intForColumn:@"popularity"];
        
        _notes_list = [NSMutableArray arrayWithCapacity:0];
        FMResultSet * rs =  [[GKDBCore sharedDB] queryDataWithSQL:QUERY_NOTE_SQL ArgsDict:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:_entity_id], @"entity_id", nil]];
        while ([rs next]) {
            GKNote * _note = [[GKNote alloc] initFromSQLiteWithRS:rs];
            [_notes_list addObject:_note];
        }
        
    _entitylike = [GKEntityLike getEntityLikeStatusFromSQLiteWithEntityID:_entity_id];
    }
    
    return self;
}

- (id)initWithAttributes:(NSDictionary *)attributes
{
    self = [super init];
    if (self)
    {
        _entity_id = [[attributes valueForKeyPath:@"entity_id"] integerValue];
        _taobao_id = [attributes valueForKeyPath:@"taobao_id"];
        _entity_hash = [attributes valueForKeyPath:@"entity_hash"];
        _title = [attributes valueForKeyPath:@"title"];
        _brand = [attributes valueForKeyPath:@"brand"];
        _urlString = [attributes valueForKeyPath:@"url"];
        _imgUrlString = [attributes valueForKeyPath:@"image_url"];
        _stuff_status = [attributes valueForKeyPath:@"stuff_status"];
        _price = [[attributes valueForKey:@"price"] floatValue];
        _category_id = [[attributes valueForKey:@"category_id"] integerValue];
        _liked_count = [[attributes valueForKeyPath:@"liked_count"] integerValue];
        _created_time = [NSDate dateFromString:[attributes valueForKeyPath:@"created_time"]];
        _popularity = [[attributes valueForKeyPath:@"popularity"] integerValue];
        
        BOOL _like_status = [[[attributes valueForKeyPath:@"entity_like"] valueForKeyPath:@"status"] boolValue];
        if (_like_status){
            GKLog(@"entity_like ---------- %@", [attributes valueForKeyPath:@"entity_like"]);
            _entitylike = [[GKEntityLike alloc] initWithAttributes:[attributes valueForKeyPath:@"entity_like"]];
        }
        _notes_list = [NSMutableArray arrayWithCapacity:[[attributes valueForKey:@"notes_list"] count]];
        for (NSDictionary * noteAttribute in [attributes valueForKey:@"notes_list"])
        {
            GKNote * _note = [[GKNote alloc] initWithAttributes:noteAttribute];
            [_notes_list addObject:_note];
        }
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
        [argsDict setValue:_taobao_id forKey:@"taobao_id"];
        [argsDict setValue:_entity_hash forKey:@"entity_hash"];
        [argsDict setValue:_title forKey:@"title"];
        [argsDict setValue:_urlString forKey:@"url"];
        [argsDict setValue:_imgUrlString forKey:@"image_url"];
        [argsDict setValue:_brand forKey:@"brand"];
        [argsDict setValue:_stuff_status forKey:@"stuff_status"];
        [argsDict setValue:[NSString stringWithFormat:@"%.2f", _price] forKey:@"price"];
        [argsDict setValue:[NSString stringWithFormat:@"%u", _category_id] forKey:@"category_id"];
        [argsDict setValue:[NSString stringWithFormat:@"%u", _liked_count] forKey:@"liked_count"];
        [argsDict setValue:[NSDate stringFromDate:_created_time] forKey:@"created_time"];
        [argsDict setValue:[NSNumber numberWithInteger:_popularity] forKey:@"popularity"];
        
        
        if ([[GKDBCore sharedDB] insertDataWithSQL:INSERT_DATA_SQL ArgsDict:argsDict])
        {
//            [_entitylike saveToSQLite];
            for (GKNote * note in _notes_list)
            {
                [note saveToSQLite];
            }
            [_entitylike saveToSQLite];
        }
    }
    return self;
}


@end
