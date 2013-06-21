//
//  SingleCardViewForSelected.h
//  Grape
//
//  Created by huiter on 13-3-25.
//  Copyright (c) 2013年 guoku. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "GKDelegate.h"
#import "GKItemButton.h"
#import "GKUserButton.h"
#import "GKLikeButton.h"
#import "GKNoteLabel.h"

@class GKSelection;

@interface SingleCardViewForSelected : UIView


@property (nonatomic, strong) GKSelection * selection;

@property (nonatomic, strong) GKUserButton *avatar;
@property (nonatomic, strong) GKItemButton *img;
@property (nonatomic, strong) GKLikeButton *likeButton;
@property (nonatomic, strong) GKNoteLabel * description;
@property (nonatomic, strong) UIButton *notetime;
@property (nonatomic, strong) UILabel * authoruser;
@property (nonatomic, strong) UIButton *time;
@property (strong, nonatomic) UIButton *noteButton;
 


@property (nonatomic,weak) id<GKDelegate> delegate;

@end
