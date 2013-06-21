//
//  GKNotesActivity.m
//  Grape
//
//  Created by 谢 家欣 on 13-4-23.
//  Copyright (c) 2013年 guoku. All rights reserved.
//

#import "GKNotesActivity.h"
#import "GKNote.h"
#import "NSDate+GKHelper.h"

@implementation GKNotesActivity
@synthesize notes = _notes;
@synthesize active_date = _active_date;


- (id)initWithAttributes:(NSDictionary *)attributes
{
    self = [super init];
    if (self)
    {
        _notes = [NSMutableArray arrayWithCapacity:[[_notes valueForKeyPath:@"notes"] count]];
        for (NSDictionary * noteDict in [attributes valueForKeyPath:@"notes"])
        {
            GKNote * note = [[GKNote alloc] initWithAttributes:noteDict];
            [_notes addObject:note];
        }
        _active_date = [NSDate dateFromString:[attributes valueForKeyPath:@"active_date"]];
    }
    return self;
}
@end
