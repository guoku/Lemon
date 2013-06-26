//
//  GKLikeButton.m
//  Grape
//
//  Created by huiter on 13-4-29.
//  Copyright (c) 2013年 guoku. All rights reserved.
//

#import "GKLikeButton.h"
#import "GKAppDelegate.h"

@implementation GKLikeButton
{
@private
    __strong GKEntityLike *entityLike;
    __strong NSMutableDictionary * _message;
}
@synthesize likeButton = _likeButton;
@synthesize data = _data;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.likeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _likeButton.frame = CGRectZero;
        [_likeButton setImage:[UIImage imageNamed:@"star_m_full.png"] forState:UIControlStateNormal];
        [_likeButton setImage:[UIImage imageNamed:@"star_m_full.png"] forState:UIControlStateSelected];
        [_likeButton setImageEdgeInsets:UIEdgeInsetsMake(0, 5, 0, 0)];
        [_likeButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 8, 0, 0)];
        [_likeButton setBackgroundImage:[[UIImage imageNamed:@"button_normal.png"] stretchableImageWithLeftCapWidth:10 topCapHeight:1 ]forState:UIControlStateNormal];
        [_likeButton setBackgroundImage:[[UIImage imageNamed:@"button_normal_press.png"]stretchableImageWithLeftCapWidth:10 topCapHeight:1  ]forState:UIControlStateHighlighted];
        [_likeButton.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:14.0f]];
        [_likeButton setTitleColor:[UIColor colorWithRed:253.0f / 255.0f green:62.0f / 255.0f blue:55.0 / 255.0f alpha:1.0f] forState:UIControlStateNormal];
        [_likeButton addTarget:self action:@selector(likeButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_likeButton];
        
        _message = [[NSMutableDictionary alloc]init];
    }
    return self;
}
- (void)setData:(GKEntity *)data
{
    if([data isKindOfClass:[GKEntity class]])
    {
        _data = data;
    }
    [self setNeedsLayout];
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    if(_data !=nil)
    {
        _likeButton.enabled = YES;
    }
    else
    {
        _likeButton.enabled = NO;
    }
    
    
    if (_data.entitylike)
    {
        _likeButton.selected = _data.entitylike.status;
    }
    else
    {
        _likeButton.selected = NO;
    }
    
    _likeButton.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    [_likeButton.titleLabel setTextAlignment:UITextAlignmentLeft];
    _likeButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    NSString * _liked_count = [NSString stringWithFormat:@"收藏 %u", _data.liked_count];
    [_likeButton setTitle:_liked_count forState:UIControlStateNormal];
}

- (void)likeButtonAction:(id)sender
{
    if (![kUserDefault stringForKey:kSession])
    {
        [(GKAppDelegate *)[UIApplication sharedApplication].delegate showLoginView];
    }
    else {
        [GKMessageBoard showMBWithText:nil customView:nil delayTime:0.0];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"sync"];
        if(_likeButton.selected)
        {
            [[GAI sharedInstance].defaultTracker sendEventWithCategory:@"ItemAction"
                                                            withAction:@"unlike"
                                                             withLabel:nil
                                                             withValue:nil];
        }
        else
        {
            [[GAI sharedInstance].defaultTracker sendEventWithCategory:@"ItemAction"
                                                            withAction:@"like"
                                                             withLabel:nil
                                                             withValue:nil];
        }
        
        [GKEntityLike changeLikeActionWithEntityID:_data.entity_id Selected:_likeButton.selected Block:^(NSDictionary *dict, NSError *   error)
         {
            [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"sync"];
             if(!error)
             {
                 
                entityLike = [dict valueForKeyPath:@"content"];
                _data.liked_count = entityLike.status ? _data.liked_count + 1 : _data.liked_count - 1;
                 GKEntity * entity = (GKEntity *)_data;
                [_message setValue:@(_data.entity_id) forKey:@"entityID"];
                [_message setValue:@(_data.liked_count) forKey: @"likeCount"];
                [_message setValue:entityLike forKey:@"likeStatus"];
                [_message setValue:entity forKey:@"entity"];
                 
                [[NSNotificationCenter defaultCenter] postNotificationName:kGKN_EntityLikeChange object:nil userInfo:_message];
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
                        GKUser * _user = [[GKUser alloc]initFromSQLite];
                        [_user removeFromSQLite];
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
