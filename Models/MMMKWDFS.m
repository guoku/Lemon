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
@synthesize likes_user_list = _likes_user_list;

- (id)initWithAttributes:(NSDictionary *)attributes
{
    self = [super initWithAttributes:[attributes valueForKeyPath:@"entity"]];
    if (self)
    {
        _likes_user_list = [NSMutableArray arrayWithCapacity:[[attributes valueForKeyPath:@"collect_list"] count]];
        _notes_list = [NSMutableArray arrayWithCapacity:[[attributes valueForKeyPath:@"note_list"] count]];
        for (NSDictionary * note_attrs in [attributes valueForKeyPath:@"note_list"] )
        {
            GKNote * _note = [[GKNote alloc] initWithAttributes:note_attrs];
            [_notes_list addObject:_note];
        }
        for(NSDictionary * userbase_attrs in [attributes valueForKeyPath:@"collect_list"] ){
            
            GKUserBase * user = [[GKUserBase alloc] initWithAttributes:attributes];
            [_likes_user_list addObject:user];
        }

    }
    return self;
}

+ (void)globalKWDFSWithPid:(NSUInteger)pid Cid:(NSUInteger)cid Offset:(NSUInteger)offset Date:(NSDate *)date
                     Block:(void (^)(NSDictionary *dic, NSError * error))block
{
    NSMutableDictionary * parameters = [NSMutableDictionary dictionaryWithCapacity:4];
    [parameters setObject:[NSString stringWithFormat:@"%u",pid] forKey:@"pid"];
    [parameters setObject:[NSString stringWithFormat:@"%u",cid] forKey:@"category_id"];
    [parameters setObject:[NSString stringWithFormat:@"%u",offset] forKey:@"offset"];
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
        NSDate * date;
        for (NSDictionary *dic in _listresponse)
        {
            array = [NSMutableArray arrayWithCapacity:[[dic objectForKey:@"data"] count]];
            date = [NSDate dateFromString:[dic objectForKey:@"last_since_time"]];
            for (NSDictionary * attributes in [dic objectForKey:@"data"])
            {
                MMMKWDFS * entity = [[MMMKWDFS alloc] initWithAttributes:attributes];
                [array addObject:entity];
            }
        }
        
        if (block)
        {
            block([NSDictionary dictionaryWithObjectsAndKeys:array,@"array",date,@"time",nil], nil);
        }
     
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (block) {
            GKLog(@"%@", error);
            block([NSArray array], error);
        }
    }];
    
}
@end
