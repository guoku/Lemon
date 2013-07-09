//
//  GKFollowViewController.h
//  Grape
//
//  Created by huiter on 13-4-2.
//  Copyright (c) 2013年 guoku. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGORefreshTableHeaderView.h"
#import "AKSegmentedControl.h"

@interface GKFollowViewController : GKBaseViewController<UITableViewDelegate,UITableViewDataSource,EGORefreshTableHeaderDelegate,AKSegmentedControlDelegate>
{
    BOOL _reloading;
    EGORefreshTableHeaderView *_refreshHeaderView;
}
@property (nonatomic) NSUInteger user_id;
@property (strong, nonatomic) AKSegmentedControl *segmentedControl;
@property (strong, nonatomic) UITableView *table;
@property (strong, nonatomic) NSMutableDictionary *dataArrayDic;

-(void)reloadTableViewDataSource;
-(void)doneLoadingTableViewData:(NSString *)group;
- (id)initWithUserID:(NSUInteger)user_id withGroup:(NSString *)group;

@end
