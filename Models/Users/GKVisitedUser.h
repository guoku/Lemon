//
//  GKVisitedUser.h
//  Grape
//
//  Created by 谢家欣 on 13-4-9.
//  Copyright (c) 2013年 guoku. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GKEntity.h"
#import "GKNote.h"
#import "GKTags.h"

typedef enum {
    kUserLike = 1,
    kUserPost,
    kUserNotes,
    kUserTags,
} VisitedType;

@interface GKVisitedUser : NSObject

+ (void)visitedUserWithUserID:(NSUInteger)user_id Page:(NSUInteger)page
                        Block:(void (^)(NSArray * entitylist, NSError *error))block;

@end
