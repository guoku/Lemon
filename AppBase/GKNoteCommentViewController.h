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

@class GKNoteCommentHeaderView;
@interface GKNoteCommentViewController : GKBaseViewController<UITableViewDelegate,UITableViewDataSource,EGORefreshTableHeaderDelegate,HPGrowingTextViewDelegate>
{
    BOOL _reloading;
    EGORefreshTableHeaderView *_refreshHeaderView;
    UIView *containerView;
    HPGrowingTextView *textView;
}
@property (strong, nonatomic) UITableView *table;
@property (strong, nonatomic) UIView *mask;
@property (strong ,nonatomic) GKNote * note;
@property (strong ,nonatomic) GKEntity * entity;
@property (strong ,nonatomic) GKNoteCommentHeaderView *headerView;


- (id)initWithNote:(GKNote *)note Entity:(GKEntity *)entity;

@end
