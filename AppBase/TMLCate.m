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
        _name = [attributes valueForKeyPath:@"name"];
    }
    return self;
}
@end

