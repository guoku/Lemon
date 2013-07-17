//
//  GKNoteMessage.h
//  Grape
//
//  Created by 谢 家欣 on 13-4-22.
//  Copyright (c) 2013年 guoku. All rights reserved.
//

#import <Foundation/Foundation.h>

@class GKNote;

@interface GKNoteMessage : NSObject

@property (readonly) GKUserBase * user;
@property (readonly) GKEntityBase * entity;
@property (readonly) GKNote * note;

- (id)initWithAttributes:(NSDictionary *)attributes;
@end
