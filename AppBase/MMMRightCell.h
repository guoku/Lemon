//
//  FollowUserCell.h
//  Grape
//
//  Created by huiter on 13-4-2.
//  Copyright (c) 2013年 guoku. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GKFollowButton.h"
@class GKUser;

@interface MMMRightCell : UITableViewCell

@property (nonatomic, strong) GKUser * user;
@property (strong, nonatomic) UIButton *avatarButton;
@property (strong, nonatomic) GKUserButton *avatar;
@property (strong, nonatomic) UILabel *nickname;
@property (strong, nonatomic) UILabel *bio;
@property (strong, nonatomic) GKFollowButton *followBTN;

@property (weak,nonatomic) id<GKDelegate> delegate;

@end
