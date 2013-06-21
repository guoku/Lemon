//
//  GKEntityMessage.m
//  Grape
//
//  Created by 谢 家欣 on 13-4-22.
//  Copyright (c) 2013年 guoku. All rights reserved.
//

#import "GKEntityMessage.h"
#import "GKEntity.h"

@implementation GKEntityMessage

@synthesize entity = _entity;
@synthesize liker_id_list = _liker_id_list;
@synthesize note_id_list = _note_id_list;
@synthesize added_to_selection = _added_to_selection;

- (id)initWithAttributes:(NSDictionary *)attributes
{
    self = [super init];
    if (!attributes)
    {
        return nil;
    }
    _entity = [[GKEntity alloc] initWithAttributes:[attributes valueForKeyPath:@"entity"]];
    _liker_id_list = [attributes valueForKeyPath:@"new_liker_id_list"];
    _note_id_list = [attributes valueForKeyPath:@"new_note_id_list"];
    _added_to_selection = [[attributes valueForKeyPath:@"added_to_selection"] boolValue];
    return self;

}
@end
