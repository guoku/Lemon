//
//  GKShop.m
//  MMM
//
//  Created by huiter on 13-7-5.
//  Copyright (c) 2013年 guoku. All rights reserved.
//

#import "GKShop.h"

@implementation GKShop
@synthesize title = _title;
@synthesize price = _price;
@synthesize url = _url;

- (id)initWithAttributes:(NSDictionary *)attributes
{
    self = [super init];
    if (self)
    {
        _title = [attributes valueForKeyPath:@"shop_title"];
        _price = [[attributes valueForKey:@"price"] floatValue];
        _url = [attributes valueForKeyPath:@"url"];
    }
    return self;
}
@end
