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
@synthesize notes_list = _notes_list;

- (id)initWithAttributes:(NSDictionary *)attributes
{
    self = [super initWithAttributes:attributes];
    if (self)
    {
        _notes_list = [NSMutableArray arrayWithCapacity:[[attributes valueForKeyPath:@"note_list"] count]];
        for (NSDictionary * note_attrs in [attributes valueForKeyPath:@"note_list"] )
        {
            GKNote * _note = [[GKNote alloc] initWithAttributes:note_attrs];
            [_notes_list addObject:_note];
        }
    }
    return self;
}

+ (void)globalDetailPageWithEntityId:(NSUInteger)entity_id
                               Block:(void (^)(NSDictionary * dict, NSError * error))block {
    
    NSMutableDictionary * parameters = [[NSMutableDictionary alloc] initWithCapacity:3];
    
    [[GKAppDotNetAPIClient sharedClient] getPath:[NSString stringWithFormat:@"maria/entity/%d/detail/",entity_id] parameters:[parameters Paramters] success:^(AFHTTPRequestOperation *operation, id JSON) {
        NSLog(@"detail data %@", JSON);
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
            NSLog(@"%@", error);
            block([NSDictionary dictionary], error);
        }
    }];
}
@end
