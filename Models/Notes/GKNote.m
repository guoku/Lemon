//
//  GKNote.m
//  Grape
//
//  Created by 谢家欣 on 13-3-24.
//  Copyright (c) 2013年 guoku. All rights reserved.
//

#import "GKNote.h"
#import "GKAppDotNetAPIClient.h"
//#import "NSString+GKHelper.h"
#import "NSDate+GKHelper.h"
#import "NSDictionary+GKHelp.h"
#import "GKDBCore.h"

NSString * const GKAddNewNoteNotification = @"GKAddNewNoteNotification";

NSString * const QUERY_NOTE_SQL = @"SELECT * FROM note WHERE entity_id = :entity_id\
                                    ORDER BY updated_time";

static NSString * CREATE_NOTE_SQL = @"CREATE TABLE IF NOT EXISTS note \
                                    (id INTEGER PRIMARY KEY NOT NULL, \
                                    note_id INTEGER UNIQUE NOT NULL, \
                                    entity_id INTEGER NOT NULL, \
                                    entity_image VARCHAR(255), \
                                    added_to_selection BOOLEAN, \
                                    note TEXT, \
                                    poker_count INTEGER DEFAULT 0, \
                                    hooter_count INTEGER DEFAULT 0, \
                                    comment_count INTEGER DEFAULT 0, \
                                    created_time timestamp, \
                                    updated_time timestamp)";

static NSString * INSERT_NOTE_SQL = @"REPLACE INTO note \
                                    (note_id, entity_id, entity_image, added_to_selection, note, poker_count, hooter_count, comment_count, created_time, updated_time) \
                                    VALUES(:note_id, :entity_id, :entity_image, :added_to_selection, :note, :poker_count, :hooter_count, :comment_count, :created_time, :updated_time)";

@implementation GKNote
{
@private
    NSString * _imageURLString;
}
@synthesize note_id = _note_id;
@synthesize entity_id = _entity_id;
@synthesize added_to_selection = _added_to_selection;
@synthesize note = _note;
@synthesize poker_count = _poker_count;
@synthesize hooter_count = _hooter_count;
@synthesize comment_count = _comment_count;
@synthesize created_time = _created_time;
@synthesize updated_time = _updated_time;
@synthesize note_poke = _note_poke;
@synthesize creator = _creator;


- (id)initFromSQLiteWithRS:(FMResultSet *)rs
{
    self = [super init];
    if (self)
    {
        _note_id = [rs intForColumn:@"note_id"];
        _entity_id = [rs intForColumn:@"entity_id"];
        _added_to_selection = [rs boolForColumn:@"added_to_selection"];
        _note = [rs stringForColumn:@"note"];
        _poker_count = [rs intForColumn:@"poker_count"];
        _hooter_count = [rs intForColumn:@"hooter_count"];
        _comment_count = [rs intForColumn:@"comment_count"];
        _created_time = [NSDate dateFromString:[rs stringForColumn:@"created_time"]];
        _updated_time = [NSDate dateFromString:[rs stringForColumn:@"updated_time"]];
        _imageURLString = [rs stringForColumn:@"entity_image"];
        
        FMResultSet * rs =  [[GKDBCore sharedDB] queryDataWithSQL:QUERY_NOTE_CREATOR_SQL ArgsDict:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:_note_id], @"note_id", nil]];
        while ([rs next]) {
            _creator = [[GKCreator alloc] initFromSQLiteWithRS:rs];
        }
    }
    return self;
}

- (id)initWithAttributes:(NSDictionary *)attributes
{
    self = [super init];
    
    if (self) {
        
        _note_id = [[attributes valueForKeyPath:@"note_id"] integerValue];
        _entity_id = [[attributes valueForKeyPath:@"entity_id"] integerValue];
        _added_to_selection = [[attributes valueForKeyPath:@"added_to_selection"] boolValue];
        _note = [attributes valueForKeyPath:@"note"];
        _poker_count = [[attributes valueForKeyPath:@"poker_count"] integerValue];
        _hooter_count = [[attributes valueForKeyPath:@"hooter_count"] integerValue];
        _comment_count = [[attributes valueForKeyPath:@"comment_count"] integerValue];
        _created_time = [NSDate dateFromString:[attributes valueForKeyPath:@"created_time"]];
        _updated_time = [NSDate dateFromString:[attributes valueForKeyPath:@"updated_time"]];
        _imageURLString = [attributes valueForKeyPath:@"entity_image"];
        _creator = [[GKCreator alloc] initWithAttributes:[attributes valueForKeyPath:@"creator"]];
        _note_poke = [[GKNotePoke alloc] initWithAttributes:[attributes valueForKeyPath:@"poker"]];
    }
    
    return self;
}

- (NSURL *)imageURL
{
    return [NSURL URLWithString:_imageURLString];
}

- (BOOL)createTable
{
    return [[GKDBCore sharedDB] createTableWithSQL:CREATE_NOTE_SQL];
}

- (BOOL)saveToSQLite
{
    if ([self createTable])
    {
        NSMutableDictionary * argDict = [NSMutableDictionary dictionaryWithCapacity:10];
        [argDict setValue:[NSNumber numberWithUnsignedInteger:_note_id] forKey:@"note_id"];
        [argDict setValue:[NSNumber numberWithUnsignedInteger:_entity_id] forKey:@"entity_id"];
        [argDict setValue:_imageURLString forKey:@"entity_image"];
        [argDict setValue:[NSNumber numberWithBool:_added_to_selection] forKey:@"added_to_selection"];
        [argDict setValue:_note forKey:@"note"];
        [argDict setValue:[NSNumber numberWithUnsignedInteger:_poker_count] forKey:@"poker_count"];
        [argDict setValue:[NSNumber numberWithUnsignedInteger:_hooter_count] forKey:@"hooter_count"];
        [argDict setValue:[NSNumber numberWithUnsignedInteger:_comment_count] forKey:@"comment_count"];
        [argDict setValue:[NSDate stringFromDate:_created_time] forKey:@"created_time"];
        [argDict setValue:[NSDate stringFromDate:_updated_time] forKey:@"updated_time"];
//        GKLog(@"%@", argDict);
        if ([[GKDBCore sharedDB] insertDataWithSQL:INSERT_NOTE_SQL ArgsDict:argDict])
        {
            [_creator saveToSQLite];
        }
    }
    return NO;
}

+ (void)postEntityNoteWithEntityID:(NSUInteger)entity_id
                            NoteID:(NSUInteger)note_id
                           Content:(NSString *)content
                             Block:(void (^)(NSDictionary *note, NSError * error))block
{
    NSMutableDictionary * paramters = [NSMutableDictionary dictionaryWithCapacity:3];
    [paramters setValue:[NSString stringWithFormat:@"%u", entity_id] forKey:@"eid"];
    [paramters setValue:content forKey:@"note"];
    if (note_id != 0)
    {
        [paramters setValue:[NSString stringWithFormat:@"%u", note_id] forKey:@"note_id"];
    }
    GKLog(@"paramters %@", paramters);
    [[GKAppDotNetAPIClient sharedClient] postPath:@"note/create/" parameters:[paramters Paramters] success:^(AFHTTPRequestOperation *operation, id JSON) {
        GKLog(@"%@", JSON);
        NSUInteger res_code = [[JSON valueForKeyPath:@"res_code"] integerValue];
        NSError * aError;
        switch (res_code) {
            case SUCCESS:
            {
                NSArray * listNoteResponse = [[JSON valueForKeyPath:@"results"] valueForKeyPath:@"data"];
                NSMutableDictionary * noteDict = [NSMutableDictionary dictionaryWithCapacity:1];
                for(NSDictionary *attributes in listNoteResponse)
                {
//                    GKLog(@"%@", attributes);
                    GKNote * _note = [[GKNote alloc] initWithAttributes:attributes];
                    [noteDict setValue:_note forKey:@"content"];
//                    [_note saveToSQLite];
                    break;
                }
                if (block)
                {
                    GKLog(@"post result ------------%@", noteDict);
                    block([NSDictionary dictionaryWithDictionary:noteDict], nil);
                }
                
                [[NSNotificationCenter defaultCenter] postNotificationName:GKAddNewNoteNotification object:nil userInfo:noteDict];
            }
                break;
            case NOTE_ID_ERROR:
            {
                NSString * errorMsg = [JSON valueForKeyPath:@"res_msg"];
                NSDictionary * userInfo = [NSDictionary dictionaryWithObject:errorMsg forKey:NSLocalizedDescriptionKey];
                aError = [NSError errorWithDomain:EntityErrorDomain code:kNoteIdError userInfo:userInfo];
            }
                break;
            case PREMISSIONS_DENY:
            {
                NSString * errorMsg = [JSON valueForKeyPath:@"res_msg"];
                NSDictionary * userInfo = [NSDictionary dictionaryWithObject:errorMsg forKey:NSLocalizedDescriptionKey];
                aError = [NSError errorWithDomain:EntityErrorDomain code:kPremissonDenyError userInfo:userInfo];
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
                GKLog(@"%@", aError);
                block([NSDictionary dictionary], aError);
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if(block)
        {
            GKLog(@"%@", error);
            block([NSDictionary dictionary], error);
        }
    }];
}


+ (void)pokeEntityNoteWithNoteID:(NSUInteger)note_id
                   PokedOrHotted:(NOTE_POKE_OR_HOOT)poked_or_hooted
                           Block:(void (^)(NSDictionary * dict, NSError * error))block
{
    NSMutableDictionary * paramters = [NSMutableDictionary dictionaryWithCapacity:2];
    [paramters setObject:[NSString stringWithFormat:@"%u", note_id] forKey:@"note_id"];
    
    NSString * poke_or_hoot_URLString;
    switch (poked_or_hooted) {
        case kPoker:
            poke_or_hoot_URLString = @"note/poke/";
            break;
        case kHooter:
            poke_or_hoot_URLString = @"note/hoot/";
            break;
        default:
            break;
    }
    
    
    [[GKAppDotNetAPIClient sharedClient] postPath:poke_or_hoot_URLString parameters:[paramters Paramters] success:^(AFHTTPRequestOperation *operation, id JSON) {
       
        GKLog(@"%@", JSON);
        NSUInteger res_code = [[JSON valueForKeyPath:@"res_code"] integerValue];
        NSError * aError;
        switch (res_code) {
            case SUCCESS:
            {
                NSArray * PokeOrHootResponse = [[JSON valueForKeyPath:@"results"] valueForKeyPath:@"data"];
                NSMutableDictionary * notePokeDict = [NSMutableDictionary dictionaryWithCapacity:1];
                for (NSDictionary * attributes in PokeOrHootResponse)
                {
                    GKNotePoke * notePoke = [[GKNotePoke alloc] initWithAttributes:attributes];
                    [notePokeDict setObject:notePoke forKey:@"content"];
                    break;
                }
                if (block)
                {
                    block([NSDictionary dictionaryWithDictionary:notePokeDict], nil);
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
