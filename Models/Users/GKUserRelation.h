//
//  GKUserRelation.h
//  Grape
//
//  Created by 谢家欣 on 13-4-13.
//  Copyright (c) 2013年 guoku. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    kNoneRelation,
    kFOLLOWED,
    kFANS,
    kBothRelation,
    kMyself
} GK_USER_RELATION;

@interface GKUserRelation : NSObject

@property (readonly) NSUInteger user_id;
@property (readonly) GK_USER_RELATION status;

- (id)initWithAttributes:(NSDictionary *)attributes;
@end
