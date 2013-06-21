//
//  GKBaseViewController.h
//  Grape
//
//  Created by huiter on 13-4-28.
//  Copyright (c) 2013年 guoku. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GKDelegate.h"
#import "GAITrackedViewController.h"

@interface GKBaseViewController : GAITrackedViewController<GKDelegate>

- (void)showDetailWithEntityID:(NSUInteger)entity_id;
- (void)showDetailWithData:(GKEntity*)data;
- (void)showUserWithUserID:(NSUInteger)user_id;
- (void)showUserWithUserID:(NSUInteger)user_id WithTab:(NSUInteger)tab_id;
- (void)showTagWithTagString:(NSString *)tagString;
- (void)showCommentWithNote:(GKNote *)note;
- (void)showUserFollowWithUserID:(NSUInteger)user_id;
- (void)showUserFansWithUserID:(NSUInteger)user_id;
- (void)showWebViewWithTaobaoid:(NSString *)taobao_id;
- (void)showWebViewWithTaobaoUrl:(NSString *)taobao_url;
- (void)showUserTagWithTag:(NSString*)tagstring WithUserid:(NSUInteger)user_id;
@end
