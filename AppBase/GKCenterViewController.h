//
//  GKCenterViewController.h
//  MMM
//
//  Created by huiter on 13-6-11.
//  Copyright (c) 2013年 guoku. All rights reserved.
//

#import "GKBaseViewController.h"

@interface GKCenterViewController : GKBaseViewController<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource>
@property (strong,nonatomic) UITableView *table;
@property (strong,nonatomic) UIImageView * icon;
- (void)stageChange;
@end
