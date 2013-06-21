//
//  GKNotePoke.m
//  Grape
//
//  Created by 谢家欣 on 13-3-30.
//  Copyright (c) 2013年 guoku. All rights reserved.
//

#import "GKNotePoke.h"

@implementation GKNotePoke

@synthesize user_id = _user_id;
@synthesize note_id = _note_id;
@synthesize poked_or_hooted = _poked_or_hooted;

- (id)initWithAttributes:(NSDictionary *)attributes
{
    self = [super init];
    if (self)
    {
        _user_id = [[attributes valueForKeyPath:@"user_id"] integerValue];
        _note_id = [[attributes valueForKeyPath:@"note_id"] integerValue];
        _poked_or_hooted = [[attributes valueForKeyPath:@"poked_or_hooted"] integerValue];
    }
    return self;
}

@end
