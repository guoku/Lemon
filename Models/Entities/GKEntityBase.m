//
//  GKEntityBase.m
//  MMM
//
//  Created by huiter on 13-7-17.
//  Copyright (c) 2013年 guoku. All rights reserved.
//

#import "GKEntityBase.h"

@implementation GKEntityBase
{
@private
    NSString * _imgUrlString;
}

- (id)initWithAttributes:(NSDictionary *)attributes
{
    self = [super init];
    if (self)
    {
        _entity_id = [[attributes valueForKeyPath:@"entity_id"] integerValue];
        _brand = [attributes valueForKeyPath:@"brand"];
        _title = [attributes valueForKeyPath:@"title"];
        _imgUrlString = [attributes valueForKeyPath:@"image_url"];
    }
    return self;
}
- (NSURL *)imageURL {
    return [NSURL URLWithString:_imgUrlString];
}

@end
