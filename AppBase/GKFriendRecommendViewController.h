//
//  GKFriendRecommendViewController.h
//  Grape
//
//  Created by huiter on 13-5-4.
//  Copyright (c) 2013年 guoku. All rights reserved.
//

#import "GKBaseViewController.h"
#import "EGORefreshTableHeaderView.h"
#import "SinaWeibo.h"

@interface GKFriendRecommendViewController : GKBaseViewController<UITableViewDelegate,UITableViewDataSource,SinaWeiboDelegate,SinaWeiboRequestDelegate>
@property (strong, nonatomic) UITableView *table;
@property (strong, nonatomic) UISearchBar *searchBar;
@property (strong, nonatomic) UISearchDisplayController *searchDC;
@property (strong, nonatomic) NSMutableArray *allFriends;
@property (strong, nonatomic) NSMutableArray *filteredArray;
@property (strong, nonatomic) NSMutableDictionary *sectionDic;
@property (strong, nonatomic) NSMutableArray *allKeys;

@end
