//
//  GKMoreViewController.h
//  Grape
//
//  Created by huiter on 13-4-15.
//  Copyright (c) 2013年 guoku. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SinaWeibo.h"

@interface GKSettingViewController : GKBaseViewController<UITableViewDelegate,UITableViewDataSource,SinaWeiboDelegate,SinaWeiboRequestDelegate>
@property (strong, nonatomic) UITableView *table;

@end
