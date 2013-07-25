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
        _necessary = [[attributes valueForKeyPath:@"is_required"]boolValue];
        //_necessary = false;
        _count = 0;
        //_count = [[attributes valueForKeyPath:@"count"]intValue];
    }
    return self;
}
- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.name forKey:@"name"];
    [aCoder encodeObject:@(self.kid) forKey:@"kid"];
    [aCoder encodeObject:@(self.count) forKey:@"count"];
    [aCoder encodeObject:@(self.necessary) forKey:@"necessary"];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        self.name = [aDecoder decodeObjectForKey:@"name"];
        self.kid = [[aDecoder decodeObjectForKey:@"kid"]intValue];
        self.count = [[aDecoder decodeObjectForKey:@"count"]intValue];
        self.necessary = [[aDecoder decodeObjectForKey:@"necessary"]boolValue];
    }
    return self;
}
@end
