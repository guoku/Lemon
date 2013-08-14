//
//  GKMessageViewController.h
//  MMM
//
//  Created by huiter on 13-7-16.
//  Copyright (c) 2013年 guoku. All rights reserved.
//

#import "GKBaseViewController.h"
#import "EGORefreshTableHeaderView.h"

@interface GKMessageViewController : GKBaseViewController<UITableViewDelegate,UITableViewDataSource,EGORefreshTableHeaderDelegate>
{
    BOOL _reloading;
    EGORefreshTableHeaderView *_refreshHeaderView;
}

@property (strong, nonatomic) UITableView *table;
-(void)reloadTableViewDataSource;
-(void)doneLoadingTableViewData;
-(void)refresh;
@end
