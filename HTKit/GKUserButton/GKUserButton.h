//
//  GKUserButton.h
//  Grape
//
//  Created by huiter on 13-4-29.
//  Copyright (c) 2013年 guoku. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GKDelegate.h"
#import "GKUser.h"
#import "GKUserBase.h"
#import "GKUserBase.h"

@interface GKUserButton : UIView
@property (nonatomic,strong) GKUserBase *creator;
@property (nonatomic,strong) GKUser *user;
@property (nonatomic,strong) GKUserBase  *userBase;

@property (nonatomic, strong) UIImageView *avatarImage;
@property (nonatomic, strong) UIButton *avatarButton;
@property (nonatomic,weak) id<GKDelegate> delegate;

- (id)initWithFrame:(CGRect)frame useBg:(BOOL)yes cornerRadius:(NSUInteger)radius;
@end
