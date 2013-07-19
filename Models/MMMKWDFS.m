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
    self = [super initWithAttributes:attributes];
    if (self)
    {
        _likes_list = [NSMutableArray arrayWithCapacity:[[attributes valueForKeyPath:@"like_list"] count]];
        _notes_list = [NSMutableArray arrayWithCapacity:[[attributes valueForKeyPath:@"note_list"] count]];
        for (NSDictionary * note_attrs in [attributes valueForKeyPath:@"note_list"] )
        {
            GKNote * _note = [[GKNote alloc] initWithAttributes:note_attrs];
            [_notes_list addObject:_note];
        }

    }
    return self;
}

+ (void)globalKWDFSWithPid:(NSUInteger)pid Cid:(NSUInteger)cid Page:(NSUInteger)page
                     Block:(void (^)(NSArray *array, NSError * error))block
{
    NSMutableDictionary * parameters = [NSMutableDictionary dictionaryWithCapacity:1];
    [[GKAppDotNetAPIClient sharedClient] getPath:[NSString stringWithFormat:@"maria/phase/%d/category/%d/entities/",pid,cid] parameters:[parameters Paramters] success:^(AFHTTPRequestOperation *operation, id JSON) {
        GKLog(@"%@", JSON);
        NSArray * Response = [[JSON valueForKeyPath:@"results"] valueForKeyPath:@"data"];
        NSMutableArray * array = [NSMutableArray arrayWithCapacity:[Response count]];
        for (NSDictionary * attributes in Response)
        {
            MMMKWDFS * entity = [[MMMKWDFS alloc] initWithAttributes:attributes];
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
