//
//  GKUserButton.m
//  Grape
//
//  Created by huiter on 13-4-29.
//  Copyright (c) 2013年 guoku. All rights reserved.
//

#import "GKUserButton.h"

@implementation GKUserButton
{
@private
    UIImageView * _avatarBgImg;
    NSURL * _avatarURL;
    NSUInteger _userid;
    NSUInteger _cornerRadius;
    NSUInteger _padding;
    BOOL _useBg;
    
}
@synthesize user = _user;
@synthesize creator = _creator;
@synthesize userBase = _userBase;
@synthesize avatarImage = _avatarImage;
@synthesize avatarButton = _avatarButton;
@synthesize delegate = _delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _userid = 0;
        _useBg = YES;
        _padding = 3;
        _cornerRadius = (frame.size.width/2-_padding);
        _avatarImage = [[UIImageView alloc] init];
        [_avatarImage setFrame:CGRectZero];
        [_avatarImage setContentMode:UIViewContentModeScaleAspectFit];
        _avatarImage.layer.cornerRadius = _cornerRadius;
        _avatarImage.layer.masksToBounds = YES;
        [self addSubview:_avatarImage];
     
        _avatarBgImg = [[UIImageView alloc] initWithFrame:CGRectZero];
        [_avatarBgImg setImage:[[UIImage imageNamed:@"avatar.png"] stretchableImageWithLeftCapWidth:20 topCapHeight:20]];
    
        [self insertSubview:_avatarBgImg belowSubview:_avatarImage];
        
        
        _avatarButton= [[UIButton alloc] initWithFrame:CGRectZero];
        [_avatarButton addTarget:self action:@selector(avatarButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_avatarButton];
    }
    return self;
}
- (id)initWithFrame:(CGRect)frame useBg:(BOOL)yes cornerRadius:(NSUInteger)radius
{
    self = [super initWithFrame:frame];
    if (self) {
        _userid = 0;
        _useBg = YES;
        _avatarImage = [[UIImageView alloc] init];
        [_avatarImage setFrame:CGRectZero];
        [_avatarImage setContentMode:UIViewContentModeScaleAspectFit];
        _avatarImage.layer.cornerRadius = radius;
        _avatarImage.layer.masksToBounds = YES;
        [self addSubview:_avatarImage];
        
        _avatarBgImg = [[UIImageView alloc] initWithFrame:CGRectZero];

        if(yes)
        {
        [_avatarBgImg setImage:[[UIImage imageNamed:@"avatar.png"] stretchableImageWithLeftCapWidth:31 topCapHeight:31]];
        [self addSubview:_avatarBgImg];
        }
        
        
        _avatarButton= [[UIButton alloc] initWithFrame:CGRectZero];
        [_avatarButton addTarget:self action:@selector(avatarButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_avatarButton];
    }
    return self;
}
- (void)setCreator:(GKCreator *)data
{
    if([data isKindOfClass:[GKCreator class]])
    {
        _creator = data;
        _avatarURL = data.avatarImageURL;
        _userid = data.user_id;
    }
    [self setNeedsLayout];
}
- (void)setUser:(GKUser *)user
{
    if([user isKindOfClass:[GKUser class]])
    {
        _user = user;
        _avatarURL = [ _user.avatars avatarLargeURL];
        _userid = _user.user_id;
    }
    [self setNeedsLayout];
}
- (void)setUserBase:(GKUserBase *)userbase
{
    if([userbase isKindOfClass:[GKUserBase class]])
    {
        _userBase = userbase;
        _avatarURL = [ _userBase avatarImageURL];
        _userid = _userBase.user_id;
    }
    [self setNeedsLayout];
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    _avatarBgImg.frame =  CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    _avatarImage.frame = CGRectMake(_avatarBgImg.frame.origin.x+_padding,_avatarBgImg.frame.origin.y+_padding,_avatarBgImg.frame.size.width-2*_padding,_avatarBgImg.frame.size.height-2*_padding);
    [_avatarButton setFrame:_avatarBgImg.frame];
    
    if(_userid !=0)
    {
        [_avatarImage setImageWithURL:_avatarURL];
        _avatarButton.tag = _userid;
        _avatarButton.enabled = YES;
    }
    else
    {
        _avatarButton.enabled = NO;
    }
}
- (void)avatarButtonAction:(id)sender
{
    UIButton *button = (UIButton *)sender;
    if (!button || ![button isKindOfClass:[UIButton class]])
        return;
    if (_delegate && [_delegate respondsToSelector:@selector(showUserWithUserID:)]) {
        [_delegate showUserWithUserID:button.tag];
    }
}


@end
