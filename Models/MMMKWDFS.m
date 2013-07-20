//
//  MMMKWDFS.m
//  MMM
//
//  Created by huiter on 13-7-20.
//  Copyright (c) 2013年 guoku. All rights reserved.
//

#import "MMMKWDFS.h"

@implementation MMMKWDFS
@synthesize notes_list = _notes_list;
@synthesize likes_list = _likes_list;

- (id)initWithAttributes:(NSDictionary *)attributes
{
    self = [super initWithAttributes:[attributes valueForKeyPath:@"entity"]];
    if (self)
    {
        _likes_list = [NSMutableArray arrayWithArray:[attributes valueForKeyPath:@"collect_list"]];
        _likes_user_list = [NSMutableArray arrayWithCapacity:[[attributes valueForKeyPath:@"collect_list"] count]];
        _notes_list = [NSMutableArray arrayWithCapacity:[[attributes valueForKeyPath:@"note_list"] count]];
        for (NSDictionary * note_attrs in [attributes valueForKeyPath:@"note_list"] )
        {
            GKNote * _note = [[GKNote alloc] initWithAttributes:note_attrs];
            [_notes_list addObject:_note];
        }

    }
    return self;
}

+ (void)globalKWDFSWithPid:(NSUInteger)pid Cid:(NSUInteger)cid Page:(NSUInteger)page Date:(NSDate *)date
                     Block:(void (^)(NSArray *array, NSError * error))block
{
    NSMutableDictionary * parameters = [NSMutableDictionary dictionaryWithCapacity:4];
    [parameters setObject:[NSString stringWithFormat:@"%u",pid] forKey:@"pid"];
    [parameters setObject:[NSString stringWithFormat:@"%u",cid] forKey:@"category_id"];
    [parameters setObject:[NSString stringWithFormat:@"%u",page*30] forKey:@"offset"];
    if (!date)
    {
        NSString * dataString = [NSDate now];
        [parameters  setObject:dataString forKey:@"since_time"];
    } else {
        [parameters  setObject:[NSDate stringFromDate:date] forKey:@"since_time"];
    }
    [[GKAppDotNetAPIClient sharedClient] getPath:[NSString stringWithFormat:@"maria/read_friends_collection/"] parameters:[parameters Paramters] success:^(AFHTTPRequestOperation *operation, id JSON) {
        GKLog(@"%@", JSON);
        NSArray * _listresponse = [[JSON valueForKeyPath:@"results"] valueForKeyPath:@"data"];
        NSMutableArray * array;
        for (NSDictionary *dic in _listresponse)
        {
            array = [NSMutableArray arrayWithCapacity:[[dic objectForKey:@"data"] count]];
            for (NSDictionary * attributes in [dic objectForKey:@"data"])
            {
                //NSLog(@"%@",attributes);
                MMMKWDFS * entity = [[MMMKWDFS alloc] initWithAttributes:attributes];
                [array addObject:entity];
            }
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
