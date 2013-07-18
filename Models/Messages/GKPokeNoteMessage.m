//
//  GKPokeNoteMessage.m
//  MMM
//
//  Created by huiter on 13-7-18.
//  Copyright (c) 2013年 guoku. All rights reserved.
//

#import "GKPokeNoteMessage.h"

@implementation GKPokeNoteMessage
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
