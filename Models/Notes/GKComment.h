//
//  GKComment.h
//  Grape
//
//  Created by 谢家欣 on 13-3-28.
//  Copyright (c) 2013年 guoku. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GKUserBase.h"

extern NSString * const GKAddNewNoteCommentNotification;
extern NSString * const GKDeleteNoteCommentNotification;

@interface GKComment : NSObject

@property (readonly) NSUInteger note_id;
@property (readonly) NSUInteger comment_id;
@property (readonly) NSString * comment;
@property (readonly) NSDate * created_time;
@property (readonly) NSDate * updated_time;
@property (readonly) GKUserBase * creator;
- (id)initWithAttributes:(NSDictionary *)attributes;
+ (void)globalNoteCommetWithNoteID:(NSUInteger)note_id
                             Block:(void (^)(NSArray * comment_list, NSError * error))block;
+ (void)postNoteCommentWithNoteID:(NSUInteger)note_id Content:(NSString *)content Block:(void (^)(NSDictionary * NoteComments, NSError * error))block;
+ (void)deleteNoteCommentWithCommentID:(NSUInteger)comment_id Block:(void (^)(BOOL is_removed, NSError * error))block;

@end
