//
//  GKNotesActivity.h
//  Grape
//
//  Created by 谢 家欣 on 13-4-23.
//  Copyright (c) 2013年 guoku. All rights reserved.
//

#import <Foundation/Foundation.h>

@class GKNote;

@interface GKNotesActivity : NSObject

@property (readonly) NSMutableArray * notes;
@property (readonly) NSDate * active_date;

- (id)initWithAttributes:(NSDictionary *)attributes;
@end
