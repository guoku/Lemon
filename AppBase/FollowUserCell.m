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
@synthesize followBTN = _followBTN;
@synthesize delegate = _delegate;


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        _avatar = [[GKUserButton alloc] initWithFrame:CGRectMake(15, 10, 40, 40)];
        [self addSubview:_avatar];
        
        
        self.nickname = [[UILabel alloc]initWithFrame:CGRectMake(60, 10, 160, 15)];
        _nickname.textColor = UIColorFromRGB(0x666666);
        _nickname.font = [UIFont fontWithName:@"Helvetica" size:13];
        [_nickname setBackgroundColor:[UIColor clearColor]];
        [self addSubview:_nickname];
        
        self.bio = [[UILabel alloc]initWithFrame:CGRectZero];
        [_bio setFrame:CGRectMake(60, 25, 160, 15)];
        _bio.textColor = UIColorFromRGB(0xb8b8b8);
        _bio.lineBreakMode = NSLineBreakByTruncatingTail;
        _bio.font = [UIFont fontWithName:@"Helvetica" size:10];
        [_bio setBackgroundColor:[UIColor clearColor]];
        [self addSubview:_bio];
        
        _followBTN = [[GKFollowButton alloc]initWithFrame:CGRectZero];
        [_followBTN setFrame:CGRectMake(kScreenWidth-85,15, 70, 30)];
        [self addSubview:_followBTN];

        UIImageView * _seperatorLineImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 58, kScreenWidth, 2)];
        [_seperatorLineImageView setImage:[UIImage imageNamed:@"splitline.png"]];
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
    self.followBTN.data = _user;
    
    self.nickname.text = _user.nickname;
    if((NSNull *)_user.bio != [NSNull null])
    {
        [self.bio setText:_user.bio];
    }
}

@end
