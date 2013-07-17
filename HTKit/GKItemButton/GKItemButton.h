//
//  GKItemButton.h
//  Grape
//
//  Created by huiter on 13-4-29.
//  Copyright (c) 2013年 guoku. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GKDelegate.h"
typedef enum {
    kItemButtonWithNone = 0,
    kItemButtonWithNumProgress,
    kItemButtonWithActivityIndicator
} ItemButtonType;

@interface GKItemButton : UIView

@property (strong,nonatomic) GKEntityBase *entityBase;
@property (strong, nonatomic) GKEntity *entity;
@property (strong,nonatomic) GKNote *note;

@property (nonatomic, strong) UIImageView *img;
@property (nonatomic, strong) UIButton *itemImageButton;
@property (nonatomic,weak) id <GKDelegate> delegate;

- (void)setType:(ItemButtonType)data;
- (void)setPadding:(NSUInteger)padding;
- (void)setUseSmallImg:(BOOL)yes;

@end
