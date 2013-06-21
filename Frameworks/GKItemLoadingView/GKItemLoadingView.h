//
//  GKItemLoadingView.h
//  Grape
//
//  Created by huiter on 13-5-3.
//  Copyright (c) 2013年 guoku. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GKItemLoadingView :UIView {
    BOOL      _isAnimating;
    NSTimer*  _timer;
    BOOL      _hidesWhenStopped;
    NSInteger _currentStep;
    NSInteger _itemCount;
    CGFloat   _duration;
}

@property (nonatomic, assign)BOOL hidesWhenStopped;
@property (nonatomic, assign)NSInteger dotCount;
@property (nonatomic, assign)CGFloat duration;

- (void)startAnimating;
- (void)stopAnimating;
- (BOOL)isAnimating;

- (id)init;


@end
