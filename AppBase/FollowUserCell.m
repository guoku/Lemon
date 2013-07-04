//
//  FollowUserCell.m
//  Grape
//
//  Created by huiter on 13-4-2.
//  Copyright (c) 2013年 guoku. All rights reserved.
//

#import "FollowUserCell.h"
#import "GKUser.h"


@implementation FollowUserCell
{@private
    __strong GKUser * _user;
    __strong NSMutableDictionary * _message;
}

@synthesize user = _user;
@synthesize avatar = _avatar;
@synthesize avatarButton = _avatarButton;
@synthesize nickname = _nickname;
@synthesize bio = _bio;
@synthesize invite = _invite;
@synthesize delegate = _delegate;


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        _avatar = [[GKUserButton alloc] initWithFrame:CGRectMake(15, 4, 36, 36)];
        [self addSubview:_avatar];
        
        
        self.nickname = [[UILabel alloc]initWithFrame:CGRectMake(60, 5, 160, 20)];
        _nickname.textColor = UIColorFromRGB(0x666666);
        _nickname.font = [UIFont fontWithName:@"Helvetica" size:13];
        [_nickname setBackgroundColor:[UIColor clearColor]];
        [self addSubview:_nickname];
        
        self.bio = [[UILabel alloc]initWithFrame:CGRectZero];
        [_bio setFrame:CGRectMake(60, 25, 160, 15)];
        _bio.textColor = UIColorFromRGB(0x999999);
        _bio.lineBreakMode = NSLineBreakByTruncatingTail;
        _bio.font = [UIFont fontWithName:@"Helvetica" size:10];
        [_bio setBackgroundColor:[UIColor clearColor]];
        [self addSubview:_bio];
        
        _invite= [[UIButton alloc]initWithFrame:CGRectMake(kScreenWidth-60, 6, 50, 30)];
        [_invite setBackgroundImage:[[UIImage imageNamed:@"button_normal.png"]resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)] forState:UIControlStateNormal];
        [_invite setBackgroundImage:[[UIImage imageNamed:@"button_normal_press.png"]resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10) ] forState:UIControlStateHighlighted];
        [_invite setTitleColor:UIColorFromRGB(0x999999) forState:UIControlStateNormal];
        [_invite setTitle:@"邀请" forState:UIControlStateNormal];
        [_invite.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:12.0f]];
        [_invite addTarget:self action:@selector(showFriendRecommend) forControlEvents:UIControlEventTouchUpInside];
        [_invite.titleLabel setTextAlignment:NSTextAlignmentCenter];
        [self addSubview:_invite];
        
        UIImageView * _seperatorLineImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 43, kScreenWidth, 1)];
        [_seperatorLineImageView setImage:[UIImage imageNamed:@"splitline.png"]];
        _seperatorLineImageView.backgroundColor = [UIColor colorWithRed:238.0f / 255.0f green:238.0f / 255.0f blue:238.0 / 255.0f alpha:1.0f];
        [self addSubview:_seperatorLineImageView];
        
        _message = [[NSMutableDictionary alloc]init];
    }
    return self;
}

- (void)setData:(GKUser *)user
{
    _user  = user;
    [self setNeedsLayout];
    
}
- (void)setDelegate:(id<GKDelegate>)delegate
{
    _delegate = delegate;
    _avatar.delegate = _delegate;
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.backgroundView.frame = CGRectMake(8, 0, kScreenWidth-16, self.backgroundView.frame.size.height);
    
    self.avatar.user =_user;
    
    self.nickname.text = _user.nickname;
    if((NSNull *)_user.bio != [NSNull null])
    {
        [self.bio setText:_user.bio];
    }
}

@end
