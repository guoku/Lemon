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

@property (readonly) NSUInteger user_id;
@property (readonly) GKNote * note;
@property (readonly) NSArray * hooter_id_list;
@property (readonly) NSArray * poker_id_list;
@property (readonly) NSArray * comment_id_list;

- (id)initWithAttributes:(NSDictionary *)attributes;
@end
