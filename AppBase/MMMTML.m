//
//  MMMTML.m
//  MMM
//
//  Created by huiter on 13-6-18.
//  Copyright (c) 2013年 guoku. All rights reserved.
//

#import "MMMTML.h"
#import "TMLCate.h"
#import "TMLKeyWord.h"
#import "GKEntity.h"
@implementation MMMTML
- (id)initWithAttributes:(NSDictionary *)attributes
{
    self = [super init];
    if (self)
    {
        _type = [attributes valueForKeyPath:@"type"];
        if ([_type isEqualToString:@"cate"])
        {
            _object = [[TMLCate alloc]initWithAttributes:[attributes valueForKeyPath:@"object"]];
        }
        else if ([_type isEqualToString:@"keyword"])
        {
            _object = [[TMLKeyWord alloc]initWithAttributes:[attributes valueForKeyPath:@"object"]];
        }
        else if ([_type isEqualToString:@"entity"])
        {
            _object = [[GKEntity alloc]initWithAttributes:[attributes valueForKeyPath:@"object"]];
        }
    }
    return self;
}
@end
