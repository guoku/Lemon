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
+ (void)globalTMLWithBlock:(void (^)(NSArray * array, NSError * error))block
{
    [[GKAppDotNetAPIClient sharedClient] getPath:@"allcategories/" parameters:nil success:^(AFHTTPRequestOperation *operation, id JSON) {
        //GKLog(@"%@", JSON);
        NSUInteger res_code = [[JSON valueForKeyPath:@"res_code"] integerValue];
        NSError * aError;
        switch (res_code) {
            case SUCCESS:
            {
                NSArray *Response = [[JSON valueForKeyPath:@"results"] valueForKey:@"data"];

                NSMutableArray *mutableList = [NSMutableArray arrayWithCapacity:0];
                for(NSDictionary * Sattributes in Response){
                    TMLStage * stage = [[TMLStage alloc]initWithAttributes:Sattributes];
                    NSMutableArray * clist = [NSMutableArray arrayWithCapacity:0];
                    for (NSDictionary * Gattributes in [Sattributes objectForKey:@"g_list"]) {
                        TMLCate *cate = [[TMLCate alloc]initWithAttributes:Gattributes];
                        [clist addObject:cate];
                        NSMutableArray * klist = [NSMutableArray arrayWithCapacity:0];
                        for (NSDictionary * Kattributes in [Gattributes objectForKey:@"c_list"])
                        {
                            TMLKeyWord * keyword = [[TMLKeyWord alloc]initWithAttributes:Kattributes];
                            [clist addObject:keyword];
                        }
                    }
                    [mutableList addObject:[NSDictionary dictionaryWithObjectsAndKeys:stage,@"section",clist,@"row",nil]];
                }
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
                block([NSArray array], error);
            }
    }];
}
@end
