//
//  TMLStage.m
//  MMM
//
//  Created by huiter on 13-6-18.
//  Copyright (c) 2013年 guoku. All rights reserved.
//

#import "TMLStage.h"

@implementation TMLStage
- (id)initWithAttributes:(NSDictionary *)attributes
{
    self = [super init];
    if (self)
    {
        _name = [attributes valueForKeyPath:@"ptt"];
        _sid = [[attributes valueForKeyPath:@"pid"]intValue];
    }
    return self;
}
@end
