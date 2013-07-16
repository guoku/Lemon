//
//  GKUserViewController.h
//  AppBase
//
//  Created by huiter on 13-6-6.
//  Copyright (c) 2013年 guoku. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GKUserViewController : GKBaseViewController<UITableViewDelegate,UITableViewDataSource,UIActionSheetDelegate>
@property (nonatomic) NSUInteger user_id;
@property (nonatomic) GKUser *user;
@property (nonatomic,strong) UITableView *table;
- (id)initWithUserID:(NSUInteger)user_id;
- (id)initWithData:(GKUser *)data;
@end
