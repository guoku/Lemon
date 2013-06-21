//
//  GKNotePoke.h
//  Grape
//
//  Created by 谢家欣 on 13-3-30.
//  Copyright (c) 2013年 guoku. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    kNone,
    kPoker,
    kHooter,
} NOTE_POKE_OR_HOOT;

@interface GKNotePoke : NSObject

@property (readonly) NSUInteger user_id;
@property (readonly) NSUInteger note_id;
@property (readonly) NSUInteger poked_or_hooted;

- (id)initWithAttributes:(NSDictionary *)attributes;
@end
