//
//  UIView+GKHelper.m
//  Grape
//
//  Created by huiter on 13-4-4.
//  Copyright (c) 2013年 guoku. All rights reserved.
//

#import "UIView+GKHelper.h"
#import "GKBagde.h"

@implementation UIView (GKHelper)
- (UIView *)showBadgeWithX:(NSUInteger)x Y:(NSUInteger)y
{
    [self removeBadge];
    
    GKBagde * bagde = [[GKBagde alloc]initWithFrame:CGRectMake(0, 0, 11, 11)];
    
    bagde.frame = CGRectMake(self.frame.size.width-x,y,bagde.frame.size.width,bagde.frame.size.height);
    GKLog(@"%f",bagde.frame.origin.x);
    [bagde startAnimating];
    [self addSubview:bagde];
    return self;
}

- (void)removeBadge
{
    for (UIView *subview in self.subviews) {
        NSString *strClassName = [NSString stringWithUTF8String:object_getClassName(subview)];
        if ([strClassName isEqualToString:@"GKBagde"]) {
            GKBagde * bagde = (GKBagde *)subview;
            [bagde stopAnimating];
            [subview removeFromSuperview];
            break;
        }
    }
}
- (UIViewController *) firstViewController {
    return (UIViewController *)[self traverseResponderChainForUIViewController];
}

- (id) traverseResponderChainForUIViewController {
    id nextResponder = [self nextResponder];
    if ([nextResponder isKindOfClass:[UIViewController class]]) {
        return nextResponder;
    } else if ([nextResponder isKindOfClass:[UIView class]]) {
        return [nextResponder traverseResponderChainForUIViewController];
    } else {
        return nil;
    }
}
@end
