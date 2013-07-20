//
//  MMMFriendSelectViewController.h
//  MMM
//
//  Created by huiter on 13-7-19.
//  Copyright (c) 2013年 guoku. All rights reserved.
//

#import "GKBaseViewController.h"
#import "TMLKeyWord.h"
@interface MMMFriendSelectViewController : GKBaseViewController<UITableViewDelegate,UITableViewDataSource>
@property (strong, nonatomic) UITableView *table;
-(id)initWithPid:(NSUInteger)pid cid:(NSUInteger)cid;

@end
