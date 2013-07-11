//
//  GKNote.h
//  Grape
//
//  Created by 谢家欣 on 13-3-24.
//  Copyright (c) 2013年 guoku. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GKUserBase.h"
#import "GKNotePoke.h"

extern NSString * const GKAddNewNoteNotification;

extern NSString * const QUERY_NOTE_SQL;

@interface GKNote : NSObject

@property (readonly) NSUInteger note_id;
@property (readonly) NSUInteger entity_id;
@property (readonly) BOOL added_to_selection;
@property (readonly) NSString * note;
@property (readwrite) NSUInteger score;
@property (readwrite) NSUInteger poker_count;
@property (readwrite) NSUInteger hooter_count;
@property (readwrite) NSUInteger comment_count;
@property (readonly) NSDate * created_time;
@property (readonly) NSDate * updated_time;
@property (unsafe_unretained, readonly) NSURL * imageURL;
@property (readonly) GKUserBase * creator;
@property (nonatomic, strong) GKNotePoke * note_poke;

- (id)initWithAttributes:(NSDictionary *)attributes;

//+ (void)postEntityNoteWithEntityID:(NSUInteger)entity_id Content:(NSString *)content
//                             Block:(void (^)(NSDictionary *note, NSError * error))block;
+ (void)postEntityNoteWithEntityID:(NSUInteger)entity_id
                            NoteID:(NSUInteger)note_id
                             Score:(NSUInteger)score
                           Content:(NSString *)content
                             Block:(void (^)(NSDictionary *note, NSError * error))block;
+ (void)pokeEntityNoteWithNoteID:(NSUInteger)note_id
                   PokedOrHotted:(NOTE_POKE_OR_HOOT)poked_or_hooted
                           Block:(void (^)(NSDictionary * dict, NSError * error))block;
@end
