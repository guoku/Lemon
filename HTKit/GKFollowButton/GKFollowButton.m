//
//  GKFollowButton.m
//  Grape
//
//  Created by huiter on 13-4-29.
//  Copyright (c) 2013年 guoku. All rights reserved.
//

#import "GKFollowButton.h"
#import "GKAppDelegate.h"

@implementation GKFollowButton
{
@private
    __strong GKUserRelation * _userRelation;
    __strong NSMutableDictionary * _message;
}
@synthesize data = _data;
@synthesize followBTN = _followBTN;
@synthesize unfollowBTN = _unfollowBTN;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIEdgeInsets insets = UIEdgeInsetsMake(10, 10, 10, 10);
        self.followBTN = [[UIButton alloc]initWithFrame:CGRectZero];
              
        [_followBTN setTitle:@"加关注" forState:UIControlStateNormal];
        [_followBTN.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:12]];
        [_followBTN setBackgroundImage:[[UIImage imageNamed:@"button_red.png"] resizableImageWithCapInsets:insets]forState:UIControlStateNormal];
        [_followBTN setBackgroundImage:[[UIImage imageNamed:@"button_red_press.png"] resizableImageWithCapInsets:insets]forState:UIControlStateHighlighted];
        [_followBTN addTarget:self action:@selector(followButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [_followBTN setHidden:NO];
        [self addSubview:_followBTN];
        
        self.unfollowBTN = [[UIButton alloc]initWithFrame:CGRectZero];
        [_unfollowBTN setTitle:@"取消关注" forState:UIControlStateNormal];
        [_unfollowBTN.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:12]];
        [_unfollowBTN setTitleColor:UIColorFromRGB(0x666666) forState:UIControlStateNormal];
        [_unfollowBTN setTitleColor:UIColorFromRGB(0x666666) forState:UIControlStateHighlighted];
        [_unfollowBTN setBackgroundImage:[[UIImage imageNamed:@"button_normal.png"] resizableImageWithCapInsets:insets]forState:UIControlStateNormal];
        [_unfollowBTN setBackgroundImage:[[UIImage imageNamed:@"button_normal_press.png"] resizableImageWithCapInsets:insets]forState:UIControlStateHighlighted];
        [_unfollowBTN addTarget:self action:@selector(unfollowButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [_unfollowBTN setHidden:NO];
        [self addSubview:_unfollowBTN];
        
        _message = [[NSMutableDictionary alloc]init];
    }
    return self;
}
- (void)setData:(GKUser *)data
{
    if([data isKindOfClass:[GKUser class]])
    {
        _data = data;
        _userRelation = _data.relation;
    }
    [self setNeedsLayout];
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    self.followBTN.frame = CGRectMake(0, 0, self.frame.size.width,self.frame.size.height);
    self.unfollowBTN.frame = CGRectMake(0, 0, self.frame.size.width,self.frame.size.height);
    if(_data !=nil)
    {
        _unfollowBTN.tag = _data.user_id;
        _followBTN.tag = _data.user_id;
        _unfollowBTN.enabled = YES;
        _followBTN.enabled = YES;
    }
    else
    {
        _unfollowBTN.enabled = NO;
        _followBTN.enabled = NO;
    }
    switch (_userRelation.status) {
        case kNoneRelation:
            [self.followBTN setImage:nil forState:UIControlStateNormal];
            [self.unfollowBTN setHidden:YES];
            [self.followBTN setHidden:NO];
            break;
        case kFOLLOWED:
            [self.unfollowBTN setImage:nil forState:UIControlStateNormal];
            [self.unfollowBTN setHidden:NO];
            [self.followBTN setHidden:YES];
            break;
        case kFANS:
            [self.followBTN setImage:[UIImage imageNamed:@"follow_befollow.png"] forState:UIControlStateNormal];
            [self.unfollowBTN setHidden:YES];
            [self.followBTN setHidden:NO];
            break;
        case kBothRelation:
            [self.unfollowBTN setImage:[UIImage imageNamed:@"follow_both.png"] forState:UIControlStateNormal];
            [self.unfollowBTN setHidden:NO];
            [self.followBTN setHidden:YES];
            break;
        case kMyself:
        {
            [self.followBTN setImage:nil forState:UIControlStateNormal];
            [self.unfollowBTN setImage:nil forState:UIControlStateNormal];
            [self.unfollowBTN setHidden:YES];
            [self.followBTN setHidden:YES];
        }
            break;
        default:
            break;
    }
}
- (void)followButtonAction:(id)sender
{
    UIButton *button = (UIButton *)sender;
    if (!button || ![button isKindOfClass:[UIButton class]])
        return;
    if (![kUserDefault stringForKey:kSession])
    {
        [(GKAppDelegate *)[UIApplication sharedApplication].delegate showLoginView];
    }
    else {
        
            [[GAI sharedInstance].defaultTracker sendEventWithCategory:@"FollowAction"
                                                            withAction:@"follow"
                                                             withLabel:nil
                                                             withValue:nil];
        
        [GKMessageBoard showMBWithText:nil customView:nil delayTime:0.0];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"sync"];
        [GKUser UserFollowActionWithUserID:button.tag Action:kFOLLOWED Block:^(NSDictionary *user_relation, NSError *error) {
            [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"sync"];
            if(!error)
            {
                _userRelation = [user_relation valueForKeyPath:@"content"];
                [_message setValue:@(button.tag) forKey:@"userID"];
                [_message setValue:_userRelation forKey: @"relation"];
                [[NSNotificationCenter defaultCenter] postNotificationName:kGKN_UserFollowChange object:nil userInfo:_message];
                [GKMessageBoard hideMB];
            }
            else
            {
                switch (error.code) {
                    case -999:
                        [GKMessageBoard hideMB];
                        break;
                    default:
                    {
                        NSString * errorMsg = [error localizedDescription];
                        [GKMessageBoard showMBWithText:@"" detailText:errorMsg  lableFont:nil detailFont:nil customView:[[UIView alloc] initWithFrame:CGRectZero] delayTime:1.2 atHigher:NO];
                    }
                        break;
                }
            }
        }];
    }
}
- (void)unfollowButtonAction:(id)sender
{
    UIButton *button = (UIButton *)sender;
    if (!button || ![button isKindOfClass:[UIButton class]])
        return;
    if (![kUserDefault stringForKey:kSession])
    {
        [(GKAppDelegate *)[UIApplication sharedApplication].delegate showLoginView];
    }
    else {
        [[GAI sharedInstance].defaultTracker sendEventWithCategory:@"FollowAction"
                                                        withAction:@"unfollow"
                                                         withLabel:nil
                                                         withValue:nil];
        [GKMessageBoard showMBWithText:nil customView:nil delayTime:0.0];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"sync"];
        [GKUser UserFollowActionWithUserID:button.tag Action:kFANS Block:^(NSDictionary *user_relation, NSError *error) {
            [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"sync"];
            if(!error)
            {
                _userRelation = [user_relation valueForKeyPath:@"content"];
                [_message setValue:@(button.tag) forKey:@"userID"];
                [_message setValue:_userRelation forKey: @"relation"];
                [[NSNotificationCenter defaultCenter] postNotificationName:kGKN_UserFollowChange object:nil userInfo:_message];
                [GKMessageBoard hideMB];
            }
            else
            {
                switch (error.code) {
                    case -999:
                        [GKMessageBoard hideMB];
                        break;
                    case kUserSessionError:
                    {
                        [GKMessageBoard hideMB];
                
                    
                        GKAppDelegate *delegate = (GKAppDelegate *)[UIApplication sharedApplication].delegate;
                        [delegate.sinaweibo logOut];
                        [[NSNotificationCenter defaultCenter] postNotificationName:GKUserLogoutNotification object:nil];
                        [(GKAppDelegate *)[UIApplication sharedApplication].delegate showLoginView];
                    }
                        break;
                    default:
                    {
                        NSString * errorMsg = [error localizedDescription];
                        [GKMessageBoard showMBWithText:@"" detailText:errorMsg  lableFont:nil detailFont:nil customView:[[UIView alloc] initWithFrame:CGRectZero] delayTime:1.2 atHigher:NO];
                    }
                        break;
                }
            }
        }];
    }
}


@end
