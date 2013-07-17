//
//  GKDelegate.h
//  Grape
//
//  Created by huiter on 13-4-28.
//  Copyright (c) 2013年 guoku. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol GKDelegate <NSObject>

@optional
- (void)showDetailWithEntityID:(NSUInteger)entity_id;
- (void)showDetailWithData:(GKEntity*)data;

- (void)showUserWithUserID:(NSUInteger)user_id;
- (void)showUserWithUserID:(NSUInteger)user_id WithTab:(NSUInteger)tab_id;

- (void)showUserFollowWithUserID:(NSUInteger)user_id;
- (void)showUserFansWithUserID:(NSUInteger)user_id;

- (void)showWebViewWithTaobaoUrl:(NSString *)taobao_url;
- (void)replyButtonAction:(GKComment *)comment;
@end

