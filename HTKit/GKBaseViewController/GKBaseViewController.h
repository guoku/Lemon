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
- (void)showCommentWithNote:(GKNote *)note Entity:(GKEntity *)entity;
- (void)showCommentWithNoteID:(NSUInteger)note_id EntityID:(NSUInteger)entity_id;
- (void)showUserFollowWithUserID:(NSUInteger)user_id;
- (void)showUserFansWithUserID:(NSUInteger)user_id;
- (void)showWebViewWithTaobaoid:(NSString *)taobao_id;
- (void)showWebViewWithTaobaoUrl:(NSString *)taobao_url;
@end
