//
//  GKUserRelation.m
//  Grape
//
//  Created by 谢家欣 on 13-4-13.
//  Copyright (c) 2013年 guoku. All rights reserved.
//

#import "GKUserRelation.h"

@implementation GKUserRelation

@synthesize user_id = _user_id;
@synthesize status = _status;

- (id)initWithAttributes:(NSDictionary *)attributes
{
    self = [super init];
    if (self)
    {
        GKLog(@"%@",attributes);
        _user_id = [[attributes valueForKeyPath:@"user_id"] integerValue];
        _status = [[attributes valueForKeyPath:@"status"] integerValue];
    }
    
    return self;
}

@end
