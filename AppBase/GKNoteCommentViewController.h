//
//  GKNoteCommentViewController.h
//  Grape
//
//  Created by huiter on 13-3-30.
//  Copyright (c) 2013年 guoku. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGORefreshTableHeaderView.h"
#import "HPGrowingTextView.h"
#import "NoteCellDelegate.h"

@class GKNoteCommentHeaderView;
@interface GKNoteCommentViewController : GKBaseViewController<UITableViewDelegate,UITableViewDataSource,NoteCellDelegate,HPGrowingTextViewDelegate>
{
    UIView *containerView;
    HPGrowingTextView *textView;
}
@property (strong, nonatomic) UITableView *table;
@property (strong, nonatomic) UIView *mask;
@property (strong ,nonatomic) GKNote * note;
@property (strong ,nonatomic) GKEntity * entity;
@property (strong ,nonatomic) GKNoteCommentHeaderView *headerView;


- (id)initWithNote:(GKNote *)note Entity:(GKEntity *)entity;
- (id)initWithNoteID:(NSUInteger)note_id EntityID:(NSUInteger)entity_id;
- (void)replyButtonAction:(GKComment *)comment;
- (void)tapPokeRoHootButtonWithNote:(id)noteobj Poke:(id)poker;
@end
