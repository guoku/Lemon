//
//  GKSinaShareViewController.h
//  Grape
//
//  Created by huiter on 13-4-13.
//  Copyright (c) 2013年 guoku. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SinaWeibo.h"

@interface GKSinaShareViewController : GKBaseViewController<SinaWeiboDelegate,SinaWeiboRequestDelegate,UITextViewDelegate>
@property (nonatomic, strong) GKEntity * detailData;

@property (nonatomic, strong) UIImageView *seperatorLineImageView;
@property (strong, nonatomic) UIImageView *avatar;
@property (strong, nonatomic) UILabel *nickname;
@property (strong, nonatomic) UIImageView *entityImageView;
@property (nonatomic, retain) UILabel *textLengthLabel;
@property (nonatomic,retain) UITextView *textView;


- (id)initWithDetailData:(GKEntity *)data;

@end
