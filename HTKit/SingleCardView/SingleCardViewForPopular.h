//
//  FavSingleCardView.h
//  妈妈清单2.0
//
//  Created by huiter on 13-1-4.
//  Copyright (c) 2013年 妈妈清单. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GKItemButton.h"
#import "GKLikeButton.h"
#import "RatingView.h"

@interface SingleCardViewForPopular : UIView

@property (nonatomic, strong) GKEntity * entity;
@property (nonatomic, strong) GKItemButton *img;
@property (nonatomic, strong) RatingView * rating;
@property (nonatomic, strong) UILabel * brand;
@property (nonatomic, strong) UILabel * title;
@property (nonatomic, strong) UILabel * price;
@property (nonatomic, strong) GKLikeButton *likeButton;
@property (nonatomic,weak) id<GKDelegate> delegate;

@end
