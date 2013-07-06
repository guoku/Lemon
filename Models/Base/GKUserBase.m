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
@synthesize nickname = _nickname;
@synthesize gender = _gender;
@synthesize location = _location;
@synthesize city = _city;
@synthesize relation = _relation;

- (id)initWithAttributes:(NSDictionary *)attributes {
    self = [super init];
    if (self) {
        _user_id = [[attributes valueForKeyPath:@"user_id"] integerValue];
        _nickname = [attributes valueForKeyPath:@"nickname"];
        _gender = [attributes valueForKeyPath:@"gender"];
        _location = [attributes valueForKeyPath:@"location"];
        _city = [attributes valueForKeyPath:@"city"];
        _avatarImageURLString = [attributes valueForKeyPath:@"avatar_url"];
        _relation = [[GKUserRelation alloc] initWithAttributes:[attributes valueForKeyPath:@"relation"]];
    }
    return self;
}

- (NSURL *)avatarImageURL
{
    return [NSURL URLWithString:_avatarImageURLString];
}

@end
