//
//  GKFollowButton.h
//  Grape
//
//  Created by huiter on 13-4-29.
//  Copyright (c) 2013年 guoku. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GKFollowButton : UIView
@property (strong, nonatomic) GKUser *data;
@property (strong, nonatomic) UIButton *followBTN;
@property (strong, nonatomic) UIButton *unfollowBTN;
@end
