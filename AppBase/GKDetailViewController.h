//
//  GKDetailViewController.h
//  AppBase
//
//  Created by huiter on 13-6-6.
//  Copyright (c) 2013年 guoku. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GKDetailHeaderView.h"

@interface GKDetailViewController : GKBaseViewController<UITableViewDelegate,UITableViewDataSource,UIActionSheetDelegate>

@property (readonly) NSUInteger entity_id;
@property (strong, nonatomic) GKDetail *data;
@property (strong, nonatomic) GKEntity *entity;
@property (strong, nonatomic) GKDetailHeaderView *detailHeaderView;
@property (strong, nonatomic) UITableView *table;

- (id)initWithEntityID:(NSUInteger)entity_id;
- (id)initWithDate:(GKEntity * )data;
@end
