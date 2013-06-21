//
//  GKStatuBar.h
//  GKNEW
//
//  Created by huiter on 13-1-11.
//  Copyright (c) 2013年 guoku. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GKStatusBar : UIWindow

@property (nonatomic, strong) UILabel *statusLabel;

- (void)showWithMessage:(NSString *)message;

- (void)hideMessage;
@end
