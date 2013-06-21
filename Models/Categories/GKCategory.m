//
//  GKCategory.m
//  Grape
//
//  Created by 谢家欣 on 13-4-4.
//  Copyright (c) 2013年 guoku. All rights reserved.
//

#import "GKCategory.h"

@implementation GKCategory

@synthesize category_id = _category_id;
@synthesize cname = _cname;
@synthesize ename = _ename;

- (id)initWithAttributes:(NSDictionary *)attributes
{
    self = [super init];
    if (self)
    {
        _category_id = [[attributes valueForKeyPath:@"cat_id"] integerValue];
        _cname = [attributes valueForKeyPath:@"label_cn"];
        _ename = [attributes valueForKeyPath:@"label_en"];
    }
    
    return self;
}

+ (NSArray *)getCategoryList
{

    NSArray *_cateDataArray = [NSArray arrayWithObjects:
                       [NSDictionary dictionaryWithObjectsAndKeys:@"女装", @"label_cn", @" WOMEN'S", @"label_en", @"1", @"cat_id", nil],
                       [NSDictionary dictionaryWithObjectsAndKeys:@"男装", @"label_cn", @" MEN'S", @"label_en", @"2", @"cat_id", nil],
                       [NSDictionary dictionaryWithObjectsAndKeys:@"孩童", @"label_cn", @" KIDS'", @"label_en", @"3", @"cat_id", nil],
                       [NSDictionary dictionaryWithObjectsAndKeys:@"配饰", @"label_cn", @" ACCESSORIES", @"label_en", @"4", @"cat_id", nil],
                       [NSDictionary dictionaryWithObjectsAndKeys:@"美容", @"label_cn", @" BEAUTY", @"label_en", @"5", @"cat_id", nil],
                       [NSDictionary dictionaryWithObjectsAndKeys:@"科技", @"label_cn", @" TECH", @"label_en", @"6", @"cat_id", nil],
                       [NSDictionary dictionaryWithObjectsAndKeys:@"居家", @"label_cn", @" LIVING", @"label_en", @"7", @"cat_id", nil],
                       [NSDictionary dictionaryWithObjectsAndKeys:@"户外", @"label_cn", @" OUTDOORS", @"label_en", @"8", @"cat_id", nil],
                       [NSDictionary dictionaryWithObjectsAndKeys:@"文化", @"label_cn", @" CULTURE", @"label_en", @"9", @"cat_id", nil],
                       [NSDictionary dictionaryWithObjectsAndKeys:@"美食", @"label_cn", @" FOOD", @"label_en", @"10", @"cat_id", nil],
                       [NSDictionary dictionaryWithObjectsAndKeys:@"玩乐", @"label_cn", @" FUN", @"label_en", @"11", @"cat_id", nil], nil];
    
    NSMutableArray * _mutableArray = [NSMutableArray arrayWithCapacity:[_cateDataArray count]];
    for(NSDictionary * attributes in _cateDataArray)
    {
        GKCategory * category = [[GKCategory alloc] initWithAttributes:attributes];
        [_mutableArray addObject:category];
    }
    return [NSArray arrayWithArray:_mutableArray];
}
@end
