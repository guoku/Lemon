//
//  GKSelection.m
//  Grape
//
//  Created by 谢家欣 on 13-3-20.
//  Copyright (c) 2013年 guoku. All rights reserved.
//

#import "GKSelection.h"
#import "NSDictionary+GKHelp.h"
#import "NSDate+GKHelper.h"
//#import "NSString+GKHelper.h"
#import "GKAppDotNetAPIClient.h"
//#import "GTMBase64.h"

static NSString * QUERY_SQL = @"SELECT * FROM entity WHERE created_time < :created_time  \
                                ORDER BY created_time DESC limit 30";
static NSString * ALL_QUERY_SQL = @"SELECT * FROM entity WHERE created_time < :created_time  \
ORDER BY created_time DESC";

@implementation GKSelection

+ (NSArray *)getSelectionFromSQLite
{
    NSMutableDictionary * argDict = [NSMutableDictionary dictionaryWithCapacity:1];
    [argDict setValue:[NSDate now] forKey:@"created_time"];
    FMResultSet * rs = [[GKDBCore sharedDB] queryDataWithSQL:QUERY_SQL ArgsDict:argDict];
    NSMutableArray * _mutableArray = [NSMutableArray arrayWithCapacity:0];
    while ([rs next]) {
        GKSelection * selection = [[GKSelection alloc] initFromSQLiteWithRsSet:rs];
        [_mutableArray addObject:selection];
    }
    return [NSArray arrayWithArray:_mutableArray];
}
+ (NSArray *)getAllSelectionFromSQLiteWithSize:(NSUInteger)size
{
    NSMutableDictionary * argDict = [NSMutableDictionary dictionaryWithCapacity:1];
    [argDict setValue:[NSDate now] forKey:@"created_time"];
    FMResultSet * rs = [[GKDBCore sharedDB] queryDataWithSQL:[NSString stringWithFormat:@"%@ limit %d",ALL_QUERY_SQL,size] ArgsDict:argDict];
    NSMutableArray * _mutableArray = [NSMutableArray arrayWithCapacity:0];
    while ([rs next]) {
        GKSelection * selection = [[GKSelection alloc] initFromSQLiteWithRsSet:rs];
        [_mutableArray addObject:selection];
    }
    return [NSArray arrayWithArray:_mutableArray];
}

+ (void)globalSelectionsWithSize:(NSUInteger)s
                            PostBefore:(NSDate *)postbefore
                            CategoryID:(NSUInteger)category_id
                           Block:(void (^)(NSArray *selections, NSError * error))block {
    

    NSMutableDictionary * parameters = [NSMutableDictionary dictionaryWithCapacity:4];
    [parameters setObject:[NSString stringWithFormat:@"%u", s] forKey:@"size"];
    NSString * dateString;
    if (!postbefore)
    {
        dateString  = [NSDate now];
        GKLog(@"post_before = %@", dateString);
//        [parameters setObject:dateString forKey:@"post_before"];
    }
    else
    {
        dateString = [NSDate stringFromDate:postbefore];
        GKLog(@"post_before = %@", [NSDate stringFromDate:postbefore]);
        
//        [parameters setObject:[NSDate stringFromDate:postbefore] forKey:@"post_before"];
    }
    [parameters setObject:dateString forKey:@"post_before"];
    if (category_id != 0)
        [parameters setObject:[NSString stringWithFormat:@"%u", category_id] forKey:@"category_id"];
    
    [[GKAppDotNetAPIClient sharedClient] getPath:@"selected/" parameters:[parameters Paramters] success:^(AFHTTPRequestOperation *operation, id JSON) {
        //GKLog(@"%@", JSON);
        NSUInteger res_code = [[JSON valueForKeyPath:@"res_code"] integerValue];
        NSError * aError;
        switch (res_code) {
            case SUCCESS:
            {
                NSArray *listFromResponse = [[JSON valueForKeyPath:@"results"] valueForKey:@"data"];
                GKLog(@"selection %@", listFromResponse);
                NSMutableArray *mutableList = [NSMutableArray arrayWithCapacity:[listFromResponse count]];
                [[GKDBCore sharedDB] beginTransaction];
                for(NSDictionary * attributes in listFromResponse){
                    
                    GKSelection * selection = [[GKSelection alloc] initWithAttributes:attributes];
                    [mutableList addObject:selection];
                    [selection save];
                }
                [[GKDBCore sharedDB] commit];
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
        GKLog(@"%@", error);
        NSMutableDictionary * argDict = [NSMutableDictionary dictionaryWithCapacity:1];
        [argDict setValue:dateString forKey:@"created_time"];
        FMResultSet * rs =  [[GKDBCore sharedDB] queryDataWithSQL:QUERY_SQL ArgsDict:argDict];
//        GKLog(@"%@", rs);
        NSMutableArray * mutableArray = [NSMutableArray arrayWithCapacity:0];
        while ([rs next]) {
            GKSelection * selection = [[GKSelection alloc] initFromSQLiteWithRsSet:rs];
            GKLog(@"%u", selection.entity_id);
            [mutableArray addObject:selection];
        }
//        GKLog(@"data from sqlite %@", dateString);
        if ([mutableArray count] > 0)
        {
            if (block) {
                block([NSArray arrayWithArray:mutableArray], nil);
            }
        }
        else{
            if (block) {
                block([NSArray array], error);
            }
        }
    }];
}

+ (void)cancelRequestSelection
{
    [[GKAppDotNetAPIClient sharedClient] cancelAllHTTPOperationsWithMethod:@"GET" path:@"selected/"];
}

@end
