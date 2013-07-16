//
//  GKNoteCommentCell.m
//  Grape
//
//  Created by huiter on 13-3-30.
//  Copyright (c) 2013年 guoku. All rights reserved.
//

#import "GKNoteCommentCell.h"
#import "NSDate+GKHelper.h"
@implementation GKNoteCommentCell
{
@private
    __strong GKComment * _data;
    CGFloat _y;
}
@synthesize data = _data;
@synthesize nickname = _nickname;
@synthesize avatar = _avatar;
@synthesize time = _time;
@synthesize avatarButton = _avatarButton;
@synthesize seperatorLineImageView = _seperatorLineImageView;
@synthesize delegate = _delegate;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.avatar = [[GKUserButton alloc]initWithFrame:CGRectZero useBg:NO cornerRadius:2];
        [_avatar setFrame:CGRectMake(10, 13, 35, 35)];
        [self addSubview:_avatar];
        
        UIImageView * _avatarBgImg = [[UIImageView alloc] initWithFrame:CGRectMake(_avatar.frame.origin.x, _avatar.frame.origin.y , _avatar.frame.size.width+1, _avatar.frame.size.height+1)];
        [_avatarBgImg setContentMode:UIViewContentModeScaleAspectFit];
        [_avatarBgImg setImage:[[UIImage imageNamed:@"avatar_bg.png"] stretchableImageWithLeftCapWidth:20 topCapHeight:20]];
        [_avatarBgImg setBackgroundColor:[UIColor clearColor]];
        [self addSubview:_avatarBgImg];
        
        self.nickname = [[UILabel alloc]initWithFrame:CGRectMake(60, 8, 250, 15)];
        _nickname.textColor = UIColorFromRGB(0x666666);
        _nickname.font = [UIFont fontWithName:@"Helvetica-Bold" size:12];
        [_nickname setBackgroundColor:[UIColor clearColor]];
        [self addSubview:_nickname];
        
        self.comment = [[GKNoteLabel alloc]initWithFrame:CGRectMake(60,25, 240, 400)];
        _comment.content.leading = 2;
        [_comment.content setVerticalAlignment:TTTAttributedLabelVerticalAlignmentTop];
        _comment.content.font = [UIFont fontWithName:@"STHeitiSC-Light" size:12];
        _comment.content.numberOfLines = 0;
        _comment.content.lineBreakMode = NSLineBreakByWordWrapping;
        [_comment setFontsize:12];
        [self addSubview:_comment];
        
        self.avatarButton = [[UIButton alloc]initWithFrame:_nickname.frame];
        [_avatarButton addTarget:self action:@selector(avatarButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_avatarButton];
        
        self.time = [[UIButton alloc]initWithFrame:CGRectZero];
        [_time addTarget:self action:@selector(pokeButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [_time setImage:[UIImage imageNamed:@"icon_clock"] forState:UIControlStateNormal];
        [_time.titleLabel setFont:[UIFont fontWithName:@"Helvetica" size:9.0f]];
        [_time setTitleColor:UIColorFromRGB(0x999999) forState:UIControlStateNormal];
        [_time.titleLabel setTextAlignment:NSTextAlignmentLeft];
        [_time setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 2)];
        _time.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        _time.userInteractionEnabled = NO;
        [self addSubview:_time];
        
        _seperatorLineImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _seperatorLineImageView.backgroundColor = [UIColor colorWithRed:238.0f / 255.0f green:238.0f / 255.0f blue:238.0 / 255.0f alpha:1.0f]
        ;
        [self addSubview:_seperatorLineImageView];

    }
    return self;
}

- (void)setData:(GKComment *)data
{
    if ([data isKindOfClass:[GKComment class]]) {
        _data  = data;
    }

    [self setNeedsLayout];
    
}
- (void)setDelegate:(id<GKDelegate>)delegate
{
    _delegate = delegate;
    _comment.gkdelegate = _delegate;
    _avatar.delegate = _delegate;
}
- (void)avatarButtonAction:(id)sender
{
    if (_delegate && [_delegate respondsToSelector:@selector(showUserWithUserID:)]) {
        [_delegate showUserWithUserID:_data.creator.user_id];
    }
}
#pragma mark -
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.backgroundView.frame = CGRectMake(8, 0, kScreenWidth-16, self.frame.size.height);
    
    self.avatar.userBase = _data.creator;
    
    [self.nickname setText:_data.creator.nickname];

    UIFont *font = [UIFont fontWithName:@"STHeitiSC-Light" size:12];
    CGSize size = [_data.comment sizeWithFont:font constrainedToSize:CGSizeMake(240, CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping];
    [_comment setFrame:CGRectMake(_comment.frame.origin.x, _comment.frame.origin.y, 240, size.height+10)];
    _comment.comment = _data;
    
    [_time setTitle:[NSDate stringFromDate:_data.created_time WithFormatter:@"yyyy-MM-dd HH:mm"] forState:UIControlStateNormal];
    [_time setFrame:CGRectMake(190, self.frame.size.height-18, 120, 10)];
    
    [self.seperatorLineImageView setFrame:CGRectMake(0,self.frame.size.height, kScreenWidth, 1)];
    
}
+ (float)height:(GKComment *)data
{
    UIFont *font = [UIFont systemFontOfSize:12.0];
    
    CGSize size = [data.comment sizeWithFont:font constrainedToSize:CGSizeMake(240, 1000) lineBreakMode:NSLineBreakByWordWrapping];
    
    if(size.height>=15)
    {
        return size.height + 45; // 消息上下的空间，可自由调整
    }
    else
    {
        return 60;
    }
    
}
@end
