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
@synthesize entity = _entity;
@synthesize note = _note;
@synthesize user = _user;


- (id)initWithAttributes:(NSDictionary *)attributes
{
    self = [super init];
    if (self)
    {
        
        _note = [[GKNote alloc] initWithAttributes:[attributes valueForKeyPath:@"note"]];
        _entity = [[GKEntityBase alloc]initWithAttributes:[attributes valueForKeyPath:@"entity"]];
        _user = [[GKUserBase alloc]initWithAttributes:[attributes valueForKeyPath:@"user"]];
    }
    return self;
}
@end
