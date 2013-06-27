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
        _name = [attributes valueForKeyPath:@"ctt"];
        _kid =  [[attributes valueForKeyPath:@"cid"]intValue];
        //_necessary = [[attributes valueForKeyPath:@"necessary"]boolValue];
        _necessary = false;
        _count = 0;
        //_count = [[attributes valueForKeyPath:@"count"]intValue];
    }
    return self;
}
@end
