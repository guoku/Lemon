//
//  MMMTML.m
//  MMM
//
//  Created by huiter on 13-6-18.
//  Copyright (c) 2013年 guoku. All rights reserved.
//

#import "MMMTML.h"
#import "TMLStage.h"
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
+ (void)globalTMLWithBlock:(void (^)(NSDictionary * dictionary,NSArray * array, NSError * error))block
{
    [[GKAppDotNetAPIClient sharedClient] getPath:@"maria/allcategories/" parameters:nil success:^(AFHTTPRequestOperation *operation, id JSON) {
        NSUInteger res_code = [[JSON valueForKeyPath:@"res_code"] integerValue];
        NSError * aError;
        switch (res_code) {
            case SUCCESS:
            {
                NSArray *Response = [[JSON valueForKeyPath:@"results"] valueForKey:@"data"];

                NSMutableDictionary *mutableList = [[NSMutableDictionary alloc] init];
                
                NSMutableArray*mutableList2 = [[NSMutableArray alloc] init];
                
                for(NSDictionary * Sattributes in Response){
                    TMLStage * stage = [[TMLStage alloc]initWithAttributes:Sattributes];
                    NSMutableArray * list = [NSMutableArray arrayWithCapacity:0];
                    NSMutableArray * clist = [NSMutableArray arrayWithCapacity:0];
                    NSMutableDictionary * rowdic = [NSMutableDictionary dictionaryWithCapacity:0];
                    for (NSDictionary * Gattributes in [Sattributes objectForKey:@"g_list"]) {
                        NSMutableDictionary * dic = [NSMutableDictionary dictionaryWithCapacity:0];
                        TMLCate *cate = [[TMLCate alloc]initWithAttributes:Gattributes];
                        NSMutableArray * klist = [NSMutableArray arrayWithCapacity:0];
                        for (NSDictionary * Kattributes in [Gattributes objectForKey:@"c_list"])
                        {
                            TMLKeyWord * keyword = [[TMLKeyWord alloc]initWithAttributes:Kattributes];
                            [klist addObject:keyword];
                            [clist addObject:keyword];
                        }
                        [dic setObject:cate forKey:@"section"];
                        [dic setObject:klist forKey:@"row"];
                        [list addObject:dic];
                    }
                    
                    [rowdic setObject:stage forKey:@"section"];
                    [rowdic setObject:clist forKey:@"row"];
                    
                    [mutableList setObject:list forKey:@(stage.sid)];
                    [mutableList2 addObject:rowdic];
                   
                }
                if(block) {
                    block([NSDictionary dictionaryWithDictionary:mutableList],[NSArray arrayWithArray:mutableList2], nil);
                }
            }
                break;
            case OBJECT_EMPTY:
            {
                NSString * errorMsg = [JSON valueForKeyPath:@"res_msg"];
                NSDictionary * userInfo = [NSDictionary dictionaryWithObject:errorMsg forKey:NSLocalizedDescriptionKey];
                aError = [NSError errorWithDomain:EntityErrorDomain code:kEntityIsEmpty userInfo:userInfo];
            }
                break;
            default:
                break;
        }
        if (res_code != SUCCESS)
        {
            if (block)
            {
                block([NSDictionary dictionary],[NSArray array], aError);
            }
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            if (block) {
                block([NSDictionary dictionary], [NSArray array],error);
            }
    }];
}
+ (void)globalTMLEntityWithBlock:(void (^)(NSArray * array, NSError * error))block
{
    [[GKAppDotNetAPIClient sharedClient] getPath:@"maria/allcategories/" parameters:nil success:^(AFHTTPRequestOperation *operation, id JSON) {
        NSUInteger res_code = [[JSON valueForKeyPath:@"res_code"] integerValue];
        NSError * aError;
        switch (res_code) {
            case SUCCESS:
            {
               // NSArray *Response = [[JSON valueForKeyPath:@"results"] valueForKey:@"data"];
                NSMutableArray *mutableList = [[NSMutableArray alloc] init];
                

                if(block) {
                    block([NSArray arrayWithArray:mutableList], nil);
                }
            }
                break;
            case OBJECT_EMPTY:
            {
                NSString * errorMsg = [JSON valueForKeyPath:@"res_msg"];
                NSDictionary * userInfo = [NSDictionary dictionaryWithObject:errorMsg forKey:NSLocalizedDescriptionKey];
                aError = [NSError errorWithDomain:EntityErrorDomain code:kEntityIsEmpty userInfo:userInfo];
            }
                break;
            default:
                break;
        }
        if (res_code != SUCCESS)
        {
            if (block)
            {
                block([NSArray array], aError);
            }
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (block) {
            block([NSArray array],error);
        }
    }];
}
@end
