//
//  GKDetail.m
//  Grape
//
//  Created by 谢家欣 on 13-3-21.
//  Copyright (c) 2013年 guoku. All rights reserved.
//

#import "GKDetail.h"
#import "GKAppDotNetAPIClient.h"
//#import "NSString+GKHelper.h"
#import "NSDictionary+GKHelp.h"
#import "GKUserBase.h"

@implementation GKDetail
@synthesize liker_list = _liker_list;

- (id)initWithAttributes:(NSDictionary *)attributes
{
    self = [super initWithAttributes:attributes];
    if (self)
    {
        _liker_list = [NSMutableArray arrayWithCapacity:[[attributes valueForKeyPath:@"liker_list"] count]];
        for (NSDictionary * liker_attrs in [attributes valueForKeyPath:@"liker_list"] )
        {
            GKUserBase * _user = [[GKUserBase alloc] initWithAttributes:liker_attrs];
            [_liker_list addObject:_user];
        }
    }
    return self;
}


+ (void)globalDetailPageWithEntityId:(NSUInteger)entity_id
                               Block:(void (^)(NSDictionary * dict, NSError * error))block {
    
    NSMutableDictionary * parameters = [[NSMutableDictionary alloc] initWithCapacity:3];
    NSString * _entityidBystring = [NSString stringWithFormat:@"%d", entity_id];
    [parameters setObject:_entityidBystring forKey:@"eid"];
    
    [[GKAppDotNetAPIClient sharedClient] getPath:@"detail/" parameters:[parameters Paramters] success:^(AFHTTPRequestOperation *operation, id JSON) {
        GKLog(@"detail data %@", JSON);
        NSArray *listFromResponse = [[JSON listResponse] valueForKey:@"data"];
        NSMutableDictionary * _resDict = [[NSMutableDictionary alloc] initWithCapacity:1];
        for ( NSDictionary * attribute in listFromResponse)
        {
            GKDetail * _detail = [[GKDetail alloc] initWithAttributes:attribute];
            [_resDict setObject:_detail forKey:@"content"];
            break;
        }
        if (block) {
            block([NSDictionary dictionaryWithDictionary:_resDict], nil);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (block)
        {
            GKLog(@"%@", error);
            block([NSDictionary dictionary], error);
        }
    }];
}

+ (void)EntityRecommendWithEntityID:(NSUInteger)entity_id
                              Block:(void (^)(NSArray * entitylist, NSError * error))block
{
    NSMutableDictionary * paramters = [NSMutableDictionary dictionaryWithCapacity:1];
    [paramters setValue:[NSString stringWithFormat:@"%u", entity_id] forKey:@"entity_id"];
    
    [[GKAppDotNetAPIClient sharedClient] getPath:@"entity/recommend/" parameters:[paramters Paramters] success:^(AFHTTPRequestOperation *operation, id JSON) {
        GKLog(@"%@", JSON);
        NSUInteger res_code = [[JSON valueForKeyPath:@"res_code"] integerValue];
        NSArray * listResponse = [[JSON valueForKeyPath:@"results"] valueForKeyPath:@"data"];
        NSMutableArray * _mutableArray = [NSMutableArray arrayWithCapacity:[listResponse count]];
        switch (res_code) {
            case SUCCESS:
            {
                for (NSDictionary * attributes in listResponse)
                {
                    GKDetail * _entity = [[GKDetail alloc] initWithAttributes:attributes];
                    [_mutableArray addObject:_entity];
                }
                if (block)
                {
                    block([NSArray arrayWithArray:_mutableArray], nil);
                }
            }
                break;
                
            default:
                break;
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (block)
        {
            GKLog(@"%@", error);
            block([NSArray array], error);
        }
    }];
}

@end
