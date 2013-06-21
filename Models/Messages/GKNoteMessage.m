//
//  GKNoteMessage.m
//  Grape
//
//  Created by 谢 家欣 on 13-4-22.
//  Copyright (c) 2013年 guoku. All rights reserved.
//

#import "GKNoteMessage.h"
#import "GKNote.h"

@implementation GKNoteMessage
@synthesize user_id = _user_id;
@synthesize note = _note;
@synthesize hooter_id_list = _hooter_id_list;
@synthesize poker_id_list = _poker_id_list;
@synthesize comment_id_list = _comment_id_list;

- (id)initWithAttributes:(NSDictionary *)attributes
{
    self = [super init];
    if (self)
    {
        _user_id = [[attributes valueForKeyPath:@"user_id"] integerValue];
        _note = [[GKNote alloc] initWithAttributes:[attributes valueForKeyPath:@"entity_note"]];
        _hooter_id_list = [attributes valueForKeyPath:@"new_hooter_id_list"];
        _poker_id_list = [attributes valueForKeyPath:@"new_poker_id_list"];
        _comment_id_list = [attributes valueForKeyPath:@"new_comment_id_list"];
    }
    return self;
}
@end
