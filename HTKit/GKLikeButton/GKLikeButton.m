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
        [_likeButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
        [_likeButton setImage:[UIImage imageNamed:@"heart.png"] forState:UIControlStateSelected];
        [_likeButton setImage:[UIImage imageNamed:@"heart.png"] forState:UIControlStateSelected|UIControlStateHighlighted];
        [_likeButton setImage:[UIImage imageNamed:@"heart_gray.png"] forState:UIControlStateNormal];
         [_likeButton setImage:[UIImage imageNamed:@"heart_gray.png"] forState:UIControlStateNormal|UIControlStateHighlighted];
        [_likeButton setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
        [_likeButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 5, 0, 0)];

        [_likeButton setBackgroundImage:[[UIImage imageNamed:@"button_normal.png"] stretchableImageWithLeftCapWidth:10 topCapHeight:1 ]forState:UIControlStateNormal];
        [_likeButton setBackgroundImage:[[UIImage imageNamed:@"button_normal_press.png"]stretchableImageWithLeftCapWidth:10 topCapHeight:1  ]forState:UIControlStateHighlighted|UIControlStateNormal];
        [_likeButton setBackgroundImage:[[UIImage imageNamed:@"button_normal.png"] stretchableImageWithLeftCapWidth:10 topCapHeight:1 ]forState:UIControlStateSelected];
        [_likeButton setBackgroundImage:[[UIImage imageNamed:@"button_normal_press.png"]stretchableImageWithLeftCapWidth:10 topCapHeight:1  ]forState:UIControlStateHighlighted|UIControlStateSelected];
        [_likeButton.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:14.0f]];
        [_likeButton setTitleColor:[UIColor colorWithRed:253.0f / 255.0f green:62.0f / 255.0f blue:55.0 / 255.0f alpha:1.0f] forState:UIControlStateSelected];
        [_likeButton setTitleColor:[UIColor colorWithRed:253.0f / 255.0f green:62.0f / 255.0f blue:55.0 / 255.0f alpha:1.0f] forState:UIControlStateSelected|UIControlStateHighlighted];
        [_likeButton setTitleColor:UIColorFromRGB(0x999999) forState:UIControlStateNormal];
        [_likeButton setTitleColor:UIColorFromRGB(0x999999) forState:UIControlStateNormal|UIControlStateHighlighted];
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
    NSString * _liked_count;

    if(_data !=nil)
    {
        _likeButton.enabled = YES;
    }
    else
    {
        _likeButton.enabled = NO;
    }
    if (_data.entitylike.status)
    {
        _liked_count = [NSString stringWithFormat:@"已收藏"];
        _likeButton.selected = _data.entitylike.status;
    }
    else
    {
        //_liked_count = [NSString stringWithFormat:@"收藏 %u", _data.liked_count];
        _liked_count = [NSString stringWithFormat:@"收藏"];
        _likeButton.selected = NO;
    }
  
    
    _likeButton.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    [_likeButton.titleLabel setTextAlignment:NSTextAlignmentLeft];

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
                 
                 if(entityLike.status)
                 {
                 GKLog(@"%@",entity.pid_list);
                 for(NSString  * pidString in entity.pid_list ) {
                     entity.pid = [pidString integerValue];
                     [entity save];
                 }
                 }
                 else
                 {
                     [GKEntity deleteWithEntityID:entity.entity_id];
                 }
                
                [_message setValue:@(_data.entity_id) forKey:@"entityID"];
                [_message setValue:@(_data.liked_count) forKey: @"likeCount"];
                [_message setValue:entityLike forKey:@"likeStatus"];
                [_message setValue:_data forKey:@"entity"];
                 
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
