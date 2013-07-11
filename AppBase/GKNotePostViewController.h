//
//  GKNotePostViewController.h
//  Grape
//
//  Created by huiter on 13-4-4.
//  Copyright (c) 2013年 guoku. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RatingView.h"
@interface GKNotePostViewController : GKBaseViewController<RatingViewDelegate>
@property (nonatomic, strong) GKDetail * data;
@property (nonatomic, strong) RatingView *ratingView;
@property (nonatomic, strong) UIImageView *seperatorLineImageView;
@property (nonatomic, strong) UITextView *textView;
- (id)initWithDetailData:(GKDetail *)data;
@end
