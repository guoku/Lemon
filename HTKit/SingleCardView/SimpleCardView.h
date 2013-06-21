//
//  SimpleCardView.h
//  Grape
//
//  Created by huiter on 13-4-9.
//  Copyright (c) 2013年 guoku. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GKItemButton.h"
@class GKEntity;
@interface SimpleCardView : UIView

@property (nonatomic, strong) GKEntity * data;
@property (nonatomic, strong) GKItemButton *img;
@property (nonatomic,weak) id<GKDelegate> delegate;

@end
