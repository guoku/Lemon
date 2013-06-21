//
//  GKCreator.h
//  Grape
//
//  Created by 谢家欣 on 13-3-21.
//  Copyright (c) 2013年 guoku. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GKUserBase.h"

extern NSString * const QUERY_NOTE_CREATOR_SQL;

@interface GKCreator : GKUserBase

@property (readonly) NSUInteger note_id;

- (id)initWithAttributes:(NSDictionary *)attributes;
- (BOOL)saveToSQLite;
@end
