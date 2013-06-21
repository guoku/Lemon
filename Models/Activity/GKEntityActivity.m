//
//  GKEntityActivity.m
//  Grape
//
//  Created by 谢 家欣 on 13-4-23.
//  Copyright (c) 2013年 guoku. All rights reserved.
//

#import "GKEntityActivity.h"
#import "GKEntity.h"
@implementation GKEntityActivity
@synthesize entity = _entity;

- (id)initWithAttributes:(NSDictionary *)attributes
{
    self = [super init];
    if (self)
    {
        _entity = [[GKEntity alloc] initWithAttributes:[attributes valueForKeyPath:@"entity"]];
        _active_date = _entity.created_time;
    }
    return self;
}
@end
