//
//  GKTags.m
//  Grape
//
//  Created by 谢 家欣 on 13-4-2.
//  Copyright (c) 2013年 guoku. All rights reserved.
//

#import "GKTags.h"
#import "NSDate+GKHelper.h"
#import "NSDictionary+GKHelp.h"
#import "GKAppDotNetAPIClient.h"

#import "GKEntity.h"

@implementation GKTags
@synthesize tag_name = _tag_name;
@synthesize tag_encode = _tag_encode;
@synthesize tag_count = _tag_count;
@synthesize created_time = _created_time;
@synthesize creator = _creator;
@synthesize previews = _previews;

- (id)initWithAttributes:(NSDictionary *)attributes
{
    self = [super init];
    if (self)
    {
        _tag_name = [attributes valueForKeyPath:@"tag"];
        _tag_encode = [attributes valueForKeyPath:@"tag_encode"];
        _tag_count = [[attributes valueForKeyPath:@"tag_count"] integerValue];
        _created_time = [NSDate dateFromString:[attributes valueForKeyPath:@"created_time"]];
        _creator = [[GKUserBase alloc] initWithAttributes:[attributes valueForKeyPath:@"creator"]];
        _previews = [NSMutableArray arrayWithCapacity:[[attributes valueForKeyPath:@"previews"] count]];
        for (NSDictionary * entity_attributes in [attributes valueForKeyPath:@"previews"])
        {
            GKEntity * _entity = [[GKEntity alloc] initWithAttributes:entity_attributes];
            [_previews addObject:_entity];
        }
    }
    return self;
}


+ (void)globalAvaiableTagsWithBlock:(void (^)(NSArray * taglist, NSError * error))block
{
    NSMutableDictionary * paramters = [NSMutableDictionary dictionaryWithCapacity:0];
    [[GKAppDotNetAPIClient sharedClient] getPath:@"tags/list/" parameters:[paramters Paramters] success:^(AFHTTPRequestOperation *operation, id JSON) {
        GKLog(@"%@", JSON);
        
        NSArray * tagListResponse = [[JSON valueForKeyPath:@"results"] valueForKeyPath:@"data"];
        NSMutableArray * _mutableArray = [NSMutableArray arrayWithCapacity:[tagListResponse count]];
        for(NSDictionary * attributes in tagListResponse)
        {
            GKTags *tag = [[GKTags alloc] initWithAttributes:attributes];
            [_mutableArray addObject:tag];
        }
        
        if (block)
        {
            block([NSArray arrayWithArray:_mutableArray], nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if(block)
        {
            GKLog(@"%@", error);
            block([NSArray array], error);
        }
    }];
}

+ (void)globalTagsDetailWithTagName:(NSString *)tag_encode UserID:(NSUInteger)user_id Page:(NSUInteger)page Size:(NSUInteger)size Block:(void (^)(NSDictionary * dict, NSError * error))block
{
    NSMutableDictionary * parameter = [NSMutableDictionary dictionaryWithCapacity:3];
    [parameter setValue:tag_encode forKey:@"tag_encode"];
    if (user_id > 0)
        [parameter setValue:[NSNumber numberWithInteger:user_id] forKey:@"user_id"];
    [parameter setValue:[NSNumber numberWithInteger:page] forKey:@"page"];
    [parameter setValue:[NSNumber numberWithInteger:size] forKey:@"size"];
    
    [[GKAppDotNetAPIClient sharedClient] getPath:@"tags/detail/" parameters:[parameter Paramters] success:^(AFHTTPRequestOperation *operation, id JSON) {
        
        GKLog(@"%@", JSON);
        NSArray * listEntittResponse = [[JSON valueForKeyPath:@"results"] valueForKeyPath:@"data"];
//        NSMutableArray * _mutablearray = [NSMutableArray arrayWithCapacity:[listEntittResponse count]];
        NSMutableDictionary * _mutableDict = [NSMutableDictionary dictionaryWithCapacity:1];
        for (NSDictionary * attributions in listEntittResponse)
        {
//            GKEntity * entity = [[GKEntity alloc] initWithAttributes:attributions];
//            [_mutablearray addObject:entity];
            GKTags *tags = [[GKTags alloc] initWithAttributes:attributions];
//            GKLog(@"%u", entity.entity_id)
            [_mutableDict setValue:tags forKey:@"content"];
            break;
        }
        if (block)
        {
            block([NSDictionary dictionaryWithDictionary:_mutableDict], nil);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if(block)
        {
            GKLog(@"%@", error);
            block([NSDictionary dictionary], error);
        }
    }];

}
@end
