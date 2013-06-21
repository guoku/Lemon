//
//  GKCreator.m
//  Grape
//
//  Created by 谢家欣 on 13-3-21.
//  Copyright (c) 2013年 guoku. All rights reserved.
//

#import "GKCreator.h"

NSString * const QUERY_NOTE_CREATOR_SQL = @"SELECT * FROM creator WHERE note_id = :note_id";


static NSString * CREATE_NOTE_CREATOR_SQL = @"CREATE TABLE IF NOT EXISTS creator \
                            (id INTEGER PRIMARY KEY NOT NULL, \
                                note_id INTEGER UNIQUE NOT NULL, \
                                user_id INTEGER NOT NULL, \
                                nickname VARCHAR(30), \
                                bio VARCHAR(255), \
                                avatar_url VARCHAR(255))";

static NSString * INSERT_NOTE_CREATOR_SQL = @"REPLACE INTO creator (note_id, user_id, nickname, bio, avatar_url) \
                                                VALUES (:note_id, :user_id, :nickname, :bio, :avatar_url)";


@implementation GKCreator

@synthesize note_id = _note_id;


- (id)initFromSQLiteWithRS:(FMResultSet *)rs
{
    self = [super initFromSQLiteWithRS:rs];
    if (self)
    {
        _note_id = [rs intForColumn:@"note_id"];
    }
    return self;
}

- (id)initWithAttributes:(NSDictionary *)attributes {
    self = [super initWithAttributes:attributes];
    if (self) {
//        _avatarImageURLString = [attributes valueForKeyPath:@"avatar_url"];
        _note_id = [[attributes valueForKeyPath:@"note_id"] integerValue];
    }

    return self;
}

- (BOOL)createTable
{
    return [[GKDBCore sharedDB] createTableWithSQL:CREATE_NOTE_CREATOR_SQL];
}

- (BOOL)saveToSQLite
{
    if ([self createTable])
    {
        NSMutableDictionary * argDict = [NSMutableDictionary dictionaryWithCapacity:5];
        [argDict setValue:[NSNumber numberWithUnsignedInteger:_note_id] forKey:@"note_id"];
        [argDict setValue:[NSNumber numberWithUnsignedInteger:self.user_id] forKey:@"user_id"];
        [argDict setValue:self.nickname forKey:@"nickname"];
        [argDict setValue:self.bio forKey:@"bio"];
        [argDict setValue:[NSString stringWithFormat:@"%@", self.avatarImageURL] forKey:@"avatar_url"];
//        GKLog(@"%@", argDict);
        [[GKDBCore sharedDB] insertDataWithSQL:INSERT_NOTE_CREATOR_SQL ArgsDict:argDict];
    }
    return NO;
}

@end
