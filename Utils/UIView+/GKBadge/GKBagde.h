//
//  GKBagde.h
//  Grape
//
//  Created by huiter on 13-4-4.
//  Copyright (c) 2013年 guoku. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GKBagde : UIView{
    BOOL      _isAnimating;
    NSTimer*  _timer;
    BOOL      _hidesWhenStopped;
    CGFloat   _duration;
}
@property (strong,nonatomic) UIImageView *icon;
@property (nonatomic, assign)BOOL hidesWhenStopped;
@property (nonatomic, assign)CGFloat duration;

- (void)startAnimating;
- (void)stopAnimating;
- (BOOL)isAnimating;
@end
