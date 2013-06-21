//
//  GKAlertView.h
//  MMM
//
//  Created by huiter on 13-6-19.
//  Copyright (c) 2013年 guoku. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RatingView.h"
@interface GKAlertView : UIAlertView<RatingViewDelegate>
@property (strong,nonatomic) RatingView *ratingView;
@end
