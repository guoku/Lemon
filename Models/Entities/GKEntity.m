//
//  GKEntity.m
//  Grape
//
//  Created by 谢 家欣 on 13-3-27.
//  Copyright (c) 2013年 guoku. All rights reserved.
//

#import "GKEntity.h"
#import "NSDate+GKHelper.h"


@implementation GKEntity {
@private
    NSString * _imgUrlString;
}

@synthesize entity_id = _entity_id;
@synthesize pid = _pid;
@synthesize brand = _brand;
@synthesize remark_list = _remark_list;
@synthesize avg_score = _avg_score;
@synthesize purchase_list = _purchase_list;
@synthesize cid = _cid;
@synthesize title = _title;
@synthesize used_count = _used_count;
@synthesize liked_count = _liked_count;
@synthesize price = _price;
@synthesize entitylike = _entitylike;

- (id)initWithAttributes:(NSDictionary *)attributes
{
    self = [super init];
    if (self)
    {
        _entity_id = [[attributes valueForKeyPath:@"entity_id"] integerValue];
        _pid = [[attributes valueForKeyPath:@"pid"] intValue];
        _brand = [attributes valueForKeyPath:@"brand"];
        
        _remark_list = [NSMutableArray arrayWithCapacity:[[attributes valueForKey:@"remark_list"] count]];
        for (NSString * remark in [attributes valueForKey:@"remark_list"])
        {
            [_remark_list addObject:remark];
        }
        
        _cid = [[attributes valueForKeyPath:@"cid"] intValue];
        _title = [attributes valueForKeyPath:@"title"];
        _imgUrlString = [attributes valueForKeyPath:@"image_url"];
        _used_count = [[attributes valueForKeyPath:@"used_count"] integerValue];
        _liked_count = [[attributes valueForKeyPath:@"liked_count"] integerValue];
        _price = [[attributes valueForKey:@"price"] floatValue];
        //_created_time = [NSDate dateFromString:[attributes valueForKeyPath:@"created_time"]];


        
        BOOL _like_status = [[[attributes valueForKeyPath:@"entity_like"] valueForKeyPath:@"status"] boolValue];
        if (_like_status){
            GKLog(@"entity_like ---------- %@", [attributes valueForKeyPath:@"entity_like"]);
            _entitylike = [[GKEntityLike alloc] initWithAttributes:[attributes valueForKeyPath:@"entity_like"]];
        }
        _purchase_list = [NSMutableArray arrayWithCapacity:[[attributes valueForKey:@"purchase_list"] count]];
        for (NSDictionary * noteAttribute in [attributes valueForKey:@"purchase_list"])
        {
            GKShop * _shop = [[GKShop alloc] initWithAttributes:noteAttribute];
            [_purchase_list addObject:_shop];
        }
    }
    return self;
}
- (NSURL *)imageURL {
    return [NSURL URLWithString:_imgUrlString];
}


@end
