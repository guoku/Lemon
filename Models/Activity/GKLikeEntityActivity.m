//
//  GKLikeEntity.m
//  Grape
//
//  Created by 谢 家欣 on 13-4-23.
//  Copyright (c) 2013年 guoku. All rights reserved.
//

#import "GKLikeEntityActivity.h"
#import "GKEntity.h"
#import "NSDate+GKHelper.h"

@implementation GKLikeEntityActivity

@synthesize entities = _entities;

- (id)initWithAttributes:(NSDictionary *)attributes
{
    self = [super init];
    if (self)
    {
        
        _entities = [NSMutableArray arrayWithCapacity:[[attributes valueForKeyPath:@"entities"] count]];
        for (NSDictionary * entityDict in [attributes valueForKeyPath:@"entities"])
        {
            GKEntity * _entity = [[GKEntity alloc] initWithAttributes:entityDict];
            [_entities addObject:_entity];
        }
        _active_date = [NSDate dateFromString:[attributes valueForKeyPath:@"active_date"]];
    }
    
    return self;
}

@end
