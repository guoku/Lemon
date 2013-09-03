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
@synthesize item_score = _item_score;
@synthesize delivery_score = _delivery_score;
@synthesize service_score = _service_score;
@synthesize volume = _volume;

- (id)initWithAttributes:(NSDictionary *)attributes
{
    self = [super init];
    if (self)
    {
        //GKLog(@"%@",attributes);

        if(![[attributes valueForKey:@"shop_title"] isEqual:[NSNull null]])
        {
            _title = [attributes valueForKeyPath:@"shop_title"];
        }
        else
        {
            _title = @"";
        }
        _price = [[attributes valueForKey:@"price"] floatValue];
        _url = [attributes valueForKeyPath:@"url"];
        if(![[attributes valueForKey:@"volume"] isEqual:[NSNull null]])
        {
            _volume = [[attributes valueForKey:@"volume"] intValue];
        }
        else
        {
            _volume = 0;
        }
        if(![[attributes valueForKey:@"taobao_delivery_score"] isEqual:[NSNull null]])
        {
            _delivery_score = [[attributes valueForKey:@"taobao_delivery_score"] floatValue];
        }
        else
        {
            _delivery_score = 0;
        }
        if(![[attributes valueForKey:@"taobao_service_score"] isEqual:[NSNull null]])
        {
            _service_score = [[attributes valueForKey:@"taobao_service_score"] floatValue];
        }
        else
        {
            _delivery_score = 0;
        }
        if(![[attributes valueForKey:@"taobao_item_score"] isEqual:[NSNull null]])
        {
            _item_score = [[attributes valueForKey:@"taobao_item_score"] floatValue];
        }
        else
        {
            _item_score = 0;
        }
        



    }
    return self;
}
@end
