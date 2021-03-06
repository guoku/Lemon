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
    UIButton * reply;
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
        [_avatar setFrame:CGRectMake(10, 8, 35, 35)];
        [self addSubview:_avatar];
        
        /*
        UIImageView * _avatarBgImg = [[UIImageView alloc] initWithFrame:CGRectMake(_avatar.frame.origin.x, _avatar.frame.origin.y , _avatar.frame.size.width+1, _avatar.frame.size.height+1)];
        [_avatarBgImg setContentMode:UIViewContentModeScaleAspectFit];
        [_avatarBgImg setImage:[[UIImage imageNamed:@"avatar_bg.png"] stretchableImageWithLeftCapWidth:20 topCapHeight:20]];
        [_avatarBgImg setBackgroundColor:[UIColor clearColor]];
        [self addSubview:_avatarBgImg];
        */
        
        self.nickname = [[UILabel alloc]initWithFrame:CGRectMake(60, 10, 250, 15)];
        _nickname.textColor = UIColorFromRGB(0x555555);
        _nickname.font = [UIFont fontWithName:@"Helvetica-Bold" size:14];
        [_nickname setBackgroundColor:[UIColor clearColor]];
        //[self addSubview:_nickname];
        
        self.comment = [[RTLabel alloc]initWithFrame:CGRectMake(50,8, 240, 400)];
        [_comment setParagraphReplacement:@""];
        
        _comment.lineSpacing = 4.0;
        _comment.delegate = self;
                
        [self addSubview:_comment];
        
        self.avatarButton = [[UIButton alloc]initWithFrame:_nickname.frame];
        [_avatarButton addTarget:self action:@selector(avatarButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        //[self addSubview:_avatarButton];
        
        self.time = [[UIButton alloc]initWithFrame:CGRectZero];
        [_time addTarget:self action:@selector(pokeButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [_time setImage:[UIImage imageNamed:@"icon_clock"] forState:UIControlStateNormal];
        [_time.titleLabel setFont:[UIFont fontWithName:@"Helvetica" size:10.0f]];
        [_time setTitleColor:UIColorFromRGB(0x999999) forState:UIControlStateNormal];
        [_time.titleLabel setTextAlignment:NSTextAlignmentLeft];
        [_time setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 2)];
        _time.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        _time.userInteractionEnabled = NO;
        [self addSubview:_time];
        
        _seperatorLineImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _seperatorLineImageView.backgroundColor = [UIColor colorWithRed:238.0f / 255.0f green:238.0f / 255.0f blue:238.0 / 255.0f alpha:1.0f]
        ;
        [self addSubview:_seperatorLineImageView];
        
        reply = [[UIButton alloc]initWithFrame:CGRectMake(kScreenWidth-40, 0, 30, 30)];
        [reply setImage:[UIImage imageNamed:@"reply.png"] forState:UIControlStateNormal];
        [reply addTarget:self action:@selector(replyButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:reply];
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
    _avatar.delegate = _delegate;
}
- (void)avatarButtonAction:(id)sender
{
    if (_delegate && [_delegate respondsToSelector:@selector(showUserWithUserID:)]) {
        [_delegate showUserWithUserID:_data.creator.user_id];
    }
}
- (void)replyButtonAction:(id)sender
{
    if (_delegate && [_delegate respondsToSelector:@selector(replyButtonAction:)]) {
        [_delegate replyButtonAction:_data];
    }
}
#pragma mark -
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.backgroundView.frame = CGRectMake(8, 0, kScreenWidth-16, self.frame.size.height);
    
    self.avatar.userBase = _data.creator;
    
    [self.nickname setText:_data.creator.nickname];

    if(_data.reply_user.user_id)
    {
        [_comment setText:[NSString stringWithFormat:@"<a href='user:%u'><font face='Helvetica-Bold' color='#555555' size=14>%@</font></a><font face='Helvetica' color='#777777' size=14> 回复了 </font><a href='user:%u'><font face='Helvetica-Bold' color='#555555' size=14>%@: </font></a><font face='Helvetica' color='#999999' size=14>%@</font>",_data.creator.user_id,_data.creator.nickname,_data.reply_user.user_id,_data.reply_user.nickname,_data.comment]];
    }
    else
    {
        [_comment setText:[NSString stringWithFormat:@"<a href='user:%u'><font face='Helvetica-Bold' color='#555555' size=14>%@: </font></a><font face='Helvetica' color='#777777' size=14>%@</font>",_data.creator.user_id,_data.creator.nickname,_data.comment]];
        GKLog(@"%@",_data.comment);
    }
    CGSize optimumSize = [self.comment optimumSize];
	CGRect frame = [self.comment frame];
    frame.size.height = (int)optimumSize.height+5;
    
    [_comment setFrame:CGRectMake(_comment.frame.origin.x, _comment.frame.origin.y, 240, frame.size.height)];
    
    [_time setTitle:[NSDate stringFromDate:_data.created_time WithFormatter:@"MM-dd HH:mm"] forState:UIControlStateNormal];
    [_time setFrame:CGRectMake(51, self.frame.size.height-12, 120, 10)];
    
    [self.seperatorLineImageView setFrame:CGRectMake(0,self.frame.size.height, kScreenWidth, 1)];
    reply.center = CGPointMake(reply.center.x, self.frame.size.height/2);
    
    GKUser *user =[[GKUser alloc]initFromNSU];
    if(_data.creator.user_id == user.user_id)
    {
        reply.hidden = YES;
    }
    else
    {
        reply.hidden = NO;
    }
    
}
+ (float)height:(GKComment *)data
{
    
    RTLabel * rtlabel =[[RTLabel alloc]initWithFrame:CGRectMake(60,12, 240, 400)];
    
    if(data.reply_user.user_id)
    {
        GKLog(@"%@",data.reply_user);
        [rtlabel setText:[NSString stringWithFormat:@"<a href='user:%u'><font face='Helvetica-Bold' color='#555555' size=14>%@</font></a><font face='Helvetica' color='#777777' size=14> 回复了 </font><a href='user:%u'><font face='Helvetica-Bold' color='#555555' size=14>%@: </font></a><font face='Helvetica' color='#7777777' size=14>%@</font>",data.creator.user_id,data.creator.nickname,data.reply_user.user_id,data.reply_user.nickname,data.comment]];
    }
    else
    {
        [rtlabel setText:[NSString stringWithFormat:@"<a href='user:%u'><font face='Helvetica-Bold' color='#555555' size=14>%@: </font></a><font face='Helvetica' color='#777777' size=14>%@</font>",data.creator.user_id,data.creator.nickname,data.comment]];
    }
    CGSize optimumSize = [rtlabel optimumSize];
	CGRect frame = [rtlabel frame];
    frame.size.height = (int)optimumSize.height;
    
    if(frame.size.height>=15)
    {
        return frame.size.height + 35; // 消息上下的空间，可自由调整
    }
    else
    {
        return 50;
    }
    
}
- (void)rtLabel:(id)rtLabel didSelectLinkWithURL:(NSURL*)url
{
	GKLog(@"did select url %@", url);
    
    NSArray  * array= [[url absoluteString] componentsSeparatedByString:@":"];
    if([array[0] isEqualToString:@"user"])
    {
        if (_delegate && [_delegate respondsToSelector:@selector(showUserWithUserID:)]) {
            [_delegate showUserWithUserID:[array[1]integerValue]];
        }
    }
    if([array[0] isEqualToString:@"entity"])
    {
        if (_delegate && [_delegate respondsToSelector:@selector(showUserWithUserID:)]) {
            [_delegate showDetailWithEntityID:[array[1]integerValue]];
        }
    }
}
@end
