//
//  MMMKWD.m
//  MMM
//
//  Created by huiter on 13-7-8.
//  Copyright (c) 2013年 guoku. All rights reserved.
//

#import "MMMKWD.h"
#import "GKAppDotNetAPIClient.h"
#import "NSString+GKHelper.h"
#import "NSDictionary+GKHelp.h"

@implementation MMMKWD
+ (void)globalKWDWithGroup:(NSString *)group Pid:(NSUInteger)pid Cid:(NSUInteger)cid Page:(NSUInteger)page
                     Block:(void (^)(NSArray *array, NSError * error))block
{
    NSMutableDictionary * parameters = [NSMutableDictionary dictionaryWithCapacity:1];
    [parameters setValue:group forKey:@"method"];
    [parameters setValue:@((page-1)*60) forKey:@"offset"];
    [[GKAppDotNetAPIClient sharedClient] getPath:[NSString stringWithFormat:@"maria/phase/%d/category/%d/entities/",pid,cid] parameters:[parameters Paramters] success:^(AFHTTPRequestOperation *operation, id JSON) {
        GKLog(@"%@", JSON);
        NSArray * Response = [[JSON valueForKeyPath:@"results"] valueForKeyPath:@"data"];
        NSMutableArray * array = [NSMutableArray arrayWithCapacity:[Response count]];
        for (NSDictionary * attributes in Response)
        {
            GKEntity * entity = [[GKEntity alloc] initWithAttributes:attributes];
            [array addObject:entity];
        }
        if (block)
        {
            block([NSArray arrayWithArray:array], nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (block) {
            GKLog(@"%@", error);
            block([NSArray array], error);
        }
    }];
    
}
+ (void)globalNewKWDWithGroup:(NSString *)group Pid:(NSUInteger)pid Gid:(NSUInteger)gid Cid:(NSUInteger)cid Page:(NSUInteger)page
                     Block:(void (^)(NSArray *array, NSError * error))block
{
    NSMutableDictionary * parameters = [NSMutableDictionary dictionaryWithCapacity:1];
    [parameters setValue:group forKey:@"method"];
    [parameters setValue:@((page-1)*60) forKey:@"offset"];
    
    if(cid !=0)
    {
       [parameters setValue:@(cid) forKey:@"cid"];
    }
    else if(gid != 0)
    {
        [parameters setValue:@(gid) forKey:@"cgid"];
    }

    [[GKAppDotNetAPIClient sharedClient] getPath:[NSString stringWithFormat:@"maria/pgroup/%d/entities/",pid] parameters:[parameters Paramters] success:^(AFHTTPRequestOperation *operation, id JSON) {
        GKLog(@"%@", JSON);
        NSArray * Response = [[JSON valueForKeyPath:@"results"] valueForKeyPath:@"data"];
        NSMutableArray * array = [NSMutableArray arrayWithCapacity:[Response count]];
        for (NSDictionary * attributes in Response)
        {
            GKEntity * entity = [[GKEntity alloc] initWithAttributes:attributes];
            [array addObject:entity];
        }
        if (block)
        {
            block([NSArray arrayWithArray:array], nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (block) {
            GKLog(@"%@", error);
            block([NSArray array], error);
        }
    }];
    
}
@end
