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
@optional
- (void)tapPokeRoHootButtonWithNote:(id)noteobj Poke:(id)poker;
- (void)showCommentWithNote:(GKNote *)note;
@end
