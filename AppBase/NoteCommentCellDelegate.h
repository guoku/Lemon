//
//  NoteCommentDelegate.h
//  Grape
//
//  Created by huiter on 13-3-30.
//  Copyright (c) 2013年 guoku. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol NoteCommentCellDelegate <NSObject>

@optional
- (void)showUserWithUserID:(NSUInteger)user_id;
- (void)showTagWithTagString:(NSString *)tagString;
@end
