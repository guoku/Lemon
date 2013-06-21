//
//  GKPopular.m
//  Grape
//
//  Created by 谢家欣 on 13-3-23.
//  Copyright (c) 2013年 guoku. All rights reserved.
//

#import "GKPopular.h"
#import "GKAppDotNetAPIClient.h"
#import "NSString+GKHelper.h"
#import "NSDictionary+GKHelp.h"
@implementation GKPopular

+ (void)globalPopularWithGroup:(NSString *)group
                           Block:(void (^)(NSArray *populars, NSError * error))block
{
    NSMutableDictionary * parameters = [NSMutableDictionary dictionaryWithCapacity:1];
//    [parameters setValue:kGuokuApiKey forKey:@"api_key"];
    
//  group has two choices that weekly or daily and daily is default
    [parameters setValue:group forKey:@"group"];
//    [parameters setValue:[NSString SignWithParamters:parameters] forKey:@"sign"];
    
    [[GKAppDotNetAPIClient sharedClient] getPath:@"popular/" parameters:[parameters Paramters] success:^(AFHTTPRequestOperation *operation, id JSON) {
        GKLog(@"%@", JSON);
        NSArray * popularity = [[JSON valueForKeyPath:@"results"] valueForKeyPath:@"data"];
//        GKLog(@"-------------%@", popularity);
        NSMutableArray * pops = [NSMutableArray arrayWithCapacity:[popularity count]];
        for (NSDictionary * attributes in popularity)
        {
            GKPopular * pop = [[GKPopular alloc] initWithAttributes:attributes];
            [pops addObject:pop];
            GKLog(@"------------%u", pop.popularity);
        }
        if (block)
        {
            block([NSArray arrayWithArray:pops], nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (block) {
            GKLog(@"%@", error);
            block([NSArray array], error);
        }
    }];

}
@end
