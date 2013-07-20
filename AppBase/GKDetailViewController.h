//
//  GKDetailViewController.h
//  AppBase
//
//  Created by huiter on 13-6-6.
//  Copyright (c) 2013年 guoku. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GKDetailHeaderView.h"
#import "NoteCellDelegate.h"

@interface GKDetailViewController : GKBaseViewController<UITableViewDelegate,UITableViewDataSource,UIActionSheetDelegate,NoteCellDelegate>

@property (readonly) NSUInteger entity_id;
@property (strong, nonatomic) GKDetail *data;
@property (strong, nonatomic) GKDetailHeaderView *detailHeaderView;
@property (strong, nonatomic) UITableView *table;

- (id)initWithEntityID:(NSUInteger)entity_id;
- (id)initWithDate:(GKEntity * )data;
- (void)tapPokeRoHootButtonWithNote:(id)noteobj Poke:(id)poker;
@end
