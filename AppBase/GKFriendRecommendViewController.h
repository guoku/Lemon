//
//  GKFriendRecommendViewController.h
//  Grape
//
//  Created by huiter on 13-5-4.
//  Copyright (c) 2013年 guoku. All rights reserved.
//

#import "GKBaseViewController.h"
#import "EGORefreshTableHeaderView.h"

@interface GKFriendRecommendViewController : GKBaseViewController<UITableViewDelegate,UITableViewDataSource,EGORefreshTableHeaderDelegate>
{
    BOOL _reloading;
    EGORefreshTableHeaderView *_refreshHeaderView;
}
@property (strong, nonatomic) UITableView *table;
@property (strong, nonatomic) NSMutableArray *dataArray;

-(void)reloadTableViewDataSource;
- (void)doneLoadingTableViewData;

@end
