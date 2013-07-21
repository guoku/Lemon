//
//  TMLCell.h
//  MMM
//
//  Created by huiter on 13-6-20.
//  Copyright (c) 2013年 guoku. All rights reserved.
//
#import "GKDelegate.h"
#import <UIKit/UIKit.h>

@interface TMLCellForUser : UITableViewCell
@property (strong,nonatomic) NSObject *object;
@property (nonatomic, weak) id<GKDelegate> delegate;
@property (assign) NSUInteger pid;
@property (assign) NSUInteger user_id;
@end
