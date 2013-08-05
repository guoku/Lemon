//
//  TMLKeywordViewController.h
//  MMM
//
//  Created by huiter on 13-6-21.
//  Copyright (c) 2013年 guoku. All rights reserved.
//

#import "GKBaseViewController.h"
#import "TMLKeyWord.h"
#import "EGORefreshTableHeaderView.h"

@interface NewTMLKeywordViewController : GKBaseViewController<UITableViewDelegate,UITableViewDataSource,EGORefreshTableHeaderDelegate>
{
    BOOL _reloading;
    EGORefreshTableHeaderView *_refreshHeaderView;
}
@property (strong, nonatomic) UITableView *table;
@property (assign) BOOL openLeftMenu;
@property (assign) BOOL openRightMenu;
- (void)stageChange;

-(void)reloadTableViewDataSource;
-(void)doneLoadingTableViewData;

@end
