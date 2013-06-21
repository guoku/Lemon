//
//  GKDetailHeaderView.h
//  Grape
//
//  Created by huiter on 13-3-22.
//  Copyright (c) 2013年 guoku. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GKLikeButton.h"
#import "GKItemButton.h"
#import "GKDelegate.h"

@class GKEntity;

@interface GKDetailHeaderView : UIView


@property (nonatomic, strong) GKEntity * detailData;

@property (strong, nonatomic) UILabel *title;
@property (nonatomic, strong) GKItemButton *entityImageView;
@property (strong, nonatomic)  GKLikeButton *likeButton;

@property (strong, nonatomic) UIButton *buyInfoButton;
@property (strong, nonatomic) UIButton *usedButton;
@property (strong, nonatomic) UILabel * buyInfoLabel;

@property (strong, nonatomic) UIButton *noteButton;

@property (weak, nonatomic) id<GKDelegate> delegate;

- (UIImage *)image;
@end
