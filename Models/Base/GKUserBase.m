//
//  GKUserBase.m
//  Grape
//
//  Created by 谢家欣 on 13-4-28.
//  Copyright (c) 2013年 guoku. All rights reserved.
//

#import "GKUserBase.h"

@implementation GKUserBase {
@private
    NSString * _avatarImageURLString;
}

@synthesize user_id = _user_id;
@synthesize username = _username;
@synthesize nickname = _nickname;
@synthesize gender = _gender;
@synthesize location = _location;
@synthesize email = _email;
@synthesize website = _website;
@synthesize bio = _bio;

- (id)initFromSQLiteWithRS:(FMResultSet *)rs
{
    self = [super init];
    if (self)
    {
        _user_id = [rs intForColumn:@"user_id"];
        _username = [rs stringForColumn:@"username"];
        _nickname = [rs stringForColumn:@"nickname"];
        _gender = [rs stringForColumn:@"gender"];
        _location = [rs stringForColumn:@"location"];
        _email = [rs stringForColumn:@"email"];
        _bio = [rs stringForColumn:@"bio"];
        _avatarImageURLString = [rs stringForColumn:@"avatar_url"];
    }
    return self;
}

- (id)initWithAttributes:(NSDictionary *)attributes {
    self = [super init];
    if (self) {
        _user_id = [[attributes valueForKeyPath:@"user_id"] integerValue];
        _username = [attributes valueForKeyPath:@"username"];
        _nickname = [attributes valueForKeyPath:@"nickname"];
        _gender = [attributes valueForKeyPath:@"gender"];
        _location = [attributes valueForKeyPath:@"location"];
        _email = [attributes valueForKeyPath:@"email"];
        _website = [attributes valueForKeyPath:@"website"];
        _bio = [attributes valueForKeyPath:@"bio"];
        _avatarImageURLString = [attributes valueForKeyPath:@"avatar_url"];
    }
    return self;
}

- (NSURL *)avatarImageURL
{
    return [NSURL URLWithString:_avatarImageURLString];
}

@end
