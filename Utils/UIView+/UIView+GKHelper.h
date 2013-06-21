//
//  UIView+GKHelper.h
//  Grape
//
//  Created by huiter on 13-4-4.
//  Copyright (c) 2013年 guoku. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (GKHelper)
- (UIView *)showBadgeWithX:(NSUInteger)x Y:(NSUInteger)y;
- (void)removeBadge;

- (UIViewController *) firstViewController;
- (id) traverseResponderChainForUIViewController;
@end
