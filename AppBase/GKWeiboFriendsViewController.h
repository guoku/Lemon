//
//  GKWeiboFriendsViewController.h
//  Grape
//
//  Created by huiter on 13-4-18.
//  Copyright (c) 2013年 guoku. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SinaWeibo.h"

@interface GKWeiboFriendsViewController : GKBaseViewController<UITableViewDelegate,UITableViewDataSource,SinaWeiboDelegate,SinaWeiboRequestDelegate>
@property (strong, nonatomic) UITableView *table;
@property (strong, nonatomic) UISearchBar *searchBar;
@property (strong, nonatomic) UISearchDisplayController *searchDC;
@property (strong, nonatomic) NSMutableArray *allFriends;
@property (strong, nonatomic) NSMutableArray *filteredArray;
@property (strong, nonatomic) NSMutableDictionary *sectionDic;
@property (strong, nonatomic) NSMutableArray *allKeys;
@end
