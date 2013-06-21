//
//  NoteCellDelegate.h
//  Grape
//
//  Created by huiter on 13-3-26.
//  Copyright (c) 2013年 guoku. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GKNotePoke.h"


@protocol NoteCellDelegate <NSObject>
//- (void)tapPokeRoHootButtonWithNote:(id)noteobj obj:(id)sender;
@optional
- (void)tapPokeRoHootButtonWithNote:(id)noteobj Poke:(id)poker Hoot:(id)hoot Stats:(NOTE_POKE_OR_HOOT)stats;
- (void)showCommentWithNote:(GKNote *)note;
- (void)showUserWithUserID:(NSUInteger)user_id;
- (void)showTagWithTagString:(NSString *)tagString;
- (void)showCardDetailWithCardID:(NSUInteger)card_id;
- (void)showCardDetailWithData:(GKEntity*)data;
@end
