//
//  GKRightViewController.h
//  MMM
//
//  Created by huiter on 13-6-11.
//  Copyright (c) 2013年 guoku. All rights reserved.
//

#import "GKBaseViewController.h"
#import "EGORefreshTableHeaderView.h"
#import "AKSegmentedControl.h"

@interface GKRightViewController : GKBaseViewController<UITableViewDelegate,UITableViewDataSource,EGORefreshTableHeaderDelegate,AKSegmentedControlDelegate>
{
    BOOL _reloading;
    EGORefreshTableHeaderView *_refreshHeaderView;
}
@property UITableView *table;
@property (strong, nonatomic) AKSegmentedControl *segmentedControl;
@property (strong, nonatomic) NSMutableDictionary *dataArrayDic;
-(void)reloadTableViewDataSource;
-(void)doneLoadingTableViewData:(NSString *)group;

@end
