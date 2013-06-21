//
//  TMLKeyWord.m
//  MMM
//
//  Created by huiter on 13-6-18.
//  Copyright (c) 2013年 guoku. All rights reserved.
//

#import "TMLKeyWord.h"

@implementation TMLKeyWord
- (id)initWithAttributes:(NSDictionary *)attributes
{
    self = [super init];
    if (self)
    {
        _name = [attributes valueForKeyPath:@"name"];
        _open = [[attributes valueForKeyPath:@"open"]boolValue];
        _necessary = [[attributes valueForKeyPath:@"necessary"]boolValue];
        _count = [[attributes valueForKeyPath:@"count"]intValue];
    }
    return self;
}
@end
