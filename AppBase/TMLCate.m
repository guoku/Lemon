//
//  TMLCate.m
//  MMM
//
//  Created by huiter on 13-6-18.
//  Copyright (c) 2013年 guoku. All rights reserved.
//

#import "TMLCate.h"

@implementation TMLCate
- (id)initWithAttributes:(NSDictionary *)attributes
{
    self = [super init];
    if (self)
    {
        _name = [attributes valueForKeyPath:@"gtt"];
        _cid = [[attributes valueForKeyPath:@"gid"]intValue];
    }
    return self;
}
- (void)encodeWithCoder:(NSCoder *)aCoder
{
      [aCoder encodeObject:self.name forKey:@"name"];
      [aCoder encodeObject:@(self.cid) forKey:@"cid"];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
            self.name = [aDecoder decodeObjectForKey:@"name"];
            self.cid = [[aDecoder decodeObjectForKey:@"cid"]intValue];
     }
    return self;
}
@end

