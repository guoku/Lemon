//
//  TableViewCellForMessage.m
//  Grape
//
//  Created by huiter on 13-4-19.
//  Copyright (c) 2013年 guoku. All rights reserved.
//

#import "TableViewCellForMessage.h"
#import "GKUser.h"
#import "GKUserRelation.h"
#import "GKItemButton.h"
#import "GKUserButton.h"
#import "GKNoteLabel.h"
#import "SimpleCardView.h"
#import "GKFollowButton.h"
#import "GKWeiboFriendJoinMessage.h"
#import "RTLabel.h"
@implementation TableViewCellForMessage
{
@private
    __strong NSMutableDictionary * _GKmessage;
}
@synthesize delegate = _delegate;
@synthesize message = _message;


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        UIView *tempView = [[UIView alloc] init];
        [self setBackgroundView:tempView];
        [self setBackgroundColor:[UIColor clearColor]];
        _message = nil;
        _GKmessage = [[NSMutableDictionary alloc]init];
    }
    return self;
}

- (void)setMessage:(GKMessages *)message
{
    _message = message;
    [self setNeedsLayout];
}
- (void)setDelegate:(id<GKDelegate>)delegate
{
    _delegate = delegate;
    for (UIView *view in self.subviews) {
        if(([view isKindOfClass:[GKItemButton class]]))
        {
            GKItemButton * Button = (GKItemButton *)view;
            Button.delegate = _delegate;
        }
        else if([view isKindOfClass:[GKUserButton class]])
        {
            GKUserButton * Button = (GKUserButton *)view;
            Button.delegate = _delegate;
        }
        else if([view isKindOfClass:[GKNoteLabel class]])
        {
            GKNoteLabel * Button = (GKNoteLabel *)view;
            Button.gkdelegate = _delegate;
        }
        else if([view isKindOfClass:[SimpleCardView class]])
        {
            SimpleCardView * Button = (SimpleCardView *)view;
            Button.delegate = _delegate;
        }
    }
}

#pragma mark - layout subview
- (void)layoutSubviews
{
    [super layoutSubviews];
    for (UIView * view in self.subviews)
    {
        if(![view isEqual:self.backgroundView])
        {
            [view removeFromSuperview];
        }
    }
    UIImageView * icon = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 18, 18)];
    //icon.center = CGPointMake(icon.center.x,self.frame.size.height/2 );
    [self addSubview:icon];
    
    UIImageView * _seperatorLineImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, self.frame.size.height - 2, kScreenWidth, 2)];
    [_seperatorLineImageView setImage:[UIImage imageNamed:@"splitline.png"]];
    [self addSubview:_seperatorLineImageView];
    
    UIButton *_time = [[UIButton alloc]initWithFrame:CGRectMake(70, self.frame.size.height-15, 60, 10)];
    [_time addTarget:self action:@selector(pokeButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    //[_time setImage:[UIImage imageNamed:@"icon_clock"] forState:UIControlStateNormal];
    [_time.titleLabel setFont:[UIFont fontWithName:@"Helvetica" size:10.0f]];
    [_time setTitleColor:UIColorFromRGB(0x999999) forState:UIControlStateNormal];
    [_time.titleLabel setTextAlignment:NSTextAlignmentLeft];
    //[_time setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 2)];
    _time.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    _time.userInteractionEnabled = NO;
    [_time setTitle:[NSDate stringFromDate:_message.created_time WithFormatter:@"MM-dd HH:mm"] forState:UIControlStateNormal];
    [self addSubview:_time];

    if([_message.type isEqual:@"post_entity_note"])
    {
        icon.image = [UIImage imageNamed:@"message_icon5.png"];
        CGFloat y = 6;
        
        GKNoteMessage *noteMessage = ((GKNoteMessage*)_message.message_object);
        
        GKUserButton *_avatar = [[GKUserButton alloc] initWithFrame:CGRectMake(32,y+10,40,40) useBg:NO cornerRadius:0];
        [self addSubview:_avatar];
        _avatar.userBase = noteMessage.user;
        
        /*UILabel * _nickname = [[UILabel alloc]initWithFrame:CGRectZero];
        _nickname.textColor = UIColorFromRGB(0x555555);
        _nickname.font = [UIFont fontWithName:@"Helvetica-Bold" size:13];
        _nickname.text = noteMessage.user.nickname;
        [_nickname setBackgroundColor:[UIColor clearColor]];
        [self addSubview:_nickname];
        
        UIFont *font = [UIFont fontWithName:@"Helvetica-Bold" size:13];
        CGSize labelsize = [_nickname.text sizeWithFont:font constrainedToSize:CGSizeMake(CGFLOAT_MAX, _nickname.frame.size.height) lineBreakMode:NSLineBreakByWordWrapping];
        [_nickname setFrame:CGRectMake(_avatar.frame.origin.x+_avatar.frame.size.width+5,y+15,labelsize.width, 25)];
         */
        /*
        UILabel * _message_label = [[UILabel alloc]initWithFrame:CGRectMake(_nickname.frame.origin.x+_nickname.frame.size.width+5, _nickname.frame.origin.y, 120, 25)];
        _message_label.textColor = UIColorFromRGB(0x999999);
        _message_label.font = [UIFont fontWithName:@"Helvetica-Bold" size:13];
        _message_label.text = @"点评了一件商品";
        [_message_label setBackgroundColor:[UIColor clearColor]];
        [self addSubview:_message_label];
         */
        
        
        RTLabel * message_label = [[RTLabel alloc]initWithFrame:CGRectMake(_avatar.frame.origin.x+_avatar.frame.size.width+10,y+15,150,100)];
        [message_label setParagraphReplacement:@""];
        
        message_label.lineSpacing = 4.0;
        message_label.delegate = self;
        
        [message_label setText:[NSString stringWithFormat:@"<p face='Helvetica-Bold' size=13><a href='user:%u' color='#EEEEEE'>%@</a>点评了<a href='entity:%u' color='#EEEEEE'>%@</a></p>",noteMessage.user.user_id,noteMessage.user.nickname,noteMessage.entity.entity_id,noteMessage.entity.title]];
        
        [self addSubview:message_label];
        
        GKItemButton *_img = [[GKItemButton alloc] init];
        [_img setType:kItemButtonWithNumProgress];
        [_img setPadding:4];
        [_img setFrame:CGRectMake(250, y+10, 60, 60)];
        [self addSubview:_img];
        _img.entityBase = noteMessage.entity;

    }
    if([_message.type isEqual:@"user_follow_message"])
    {
        icon.image = [UIImage imageNamed:@"message_icon2.png"];
        CGFloat y = 6;
        UIButton *_noteButton = [[UIButton alloc]initWithFrame:CGRectMake(8, y+9, 250, 14)];
        [_noteButton.titleLabel setFont:[UIFont fontWithName:@"Helvetica" size:13.0f]];
        [_noteButton setTitleColor:UIColorFromRGB(0x666666) forState:UIControlStateNormal];
        [_noteButton setImage:[UIImage imageNamed:@"message_icon_user.png"] forState:UIControlStateNormal];
        [_noteButton.titleLabel setTextAlignment:NSTextAlignmentLeft];
        _noteButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [_noteButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 7, 0, 0)];
        [_noteButton setTitle:@"有 1 个人开始关注你" forState:UIControlStateNormal];
        _noteButton.userInteractionEnabled = NO;
        [self addSubview:_noteButton];
        
        y =_noteButton.frame.origin.y+_noteButton.frame.size.height;

        GKUserButton *_avatar = [[GKUserButton alloc] initWithFrame:CGRectMake(32,y+10,40,40)];
        [self addSubview:_avatar];
        _avatar.user = ((GKFollowerMessage*)_message.message_object).user;
        /*
        UILabel * _nickname = [[UILabel alloc]initWithFrame:CGRectZero];
        _nickname.textColor = UIColorFromRGB(0x666666);
        _nickname.font = [UIFont fontWithName:@"Helvetica" size:13];
        _nickname.text = ((GKFollowerMessage*)_message.message_object).user.nickname;
        [_nickname setBackgroundColor:[UIColor clearColor]];
        [self addSubview:_nickname];
        
        UIFont *font = [UIFont fontWithName:@"Helvetica" size:13];
        CGSize labelsize = [_nickname.text sizeWithFont:font constrainedToSize:CGSizeMake(CGFLOAT_MAX, _nickname.frame.size.height) lineBreakMode:NSLineBreakByWordWrapping];
        [_nickname setFrame:CGRectMake(63,y+10,labelsize.width, 25)];
        UIButton * avatarButton = [[UIButton alloc]initWithFrame:CGRectZero];
        [avatarButton addTarget:self action:@selector(avatarButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        avatarButton.frame = _nickname.frame;
        [self addSubview:avatarButton];
         */
        
        GKFollowButton * followBTN = [[GKFollowButton alloc]initWithFrame:CGRectZero];
        [followBTN setFrame:CGRectMake(kScreenWidth-90,35, 70, 30)];
        followBTN.data = ((GKFollowerMessage*)_message.message_object).user;
        [self addSubview:followBTN];
        
    }
    if([_message.type isEqual:@"friend_joined"])
    {
        icon.image = [UIImage imageNamed:@"message_icon2.png"];
        CGFloat y = 0;
        /*
        UIButton *_noteButton = [[UIButton alloc]initWithFrame:CGRectMake(8, y+9, 300, 14)];
        [_noteButton.titleLabel setFont:[UIFont fontWithName:@"Helvetica" size:13.0f]];
        [_noteButton setTitleColor:UIColorFromRGB(0x666666) forState:UIControlStateNormal];
        [_noteButton setImage:[UIImage imageNamed:@"message_icon_user.png"] forState:UIControlStateNormal];
        [_noteButton.titleLabel setTextAlignment:NSTextAlignmentLeft];
        _noteButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [_noteButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 7, 0, 0)];
        [_noteButton setTitle:[NSString stringWithFormat:@"你的微博好友 @%@ 加入果库",((GKWeiboFriendJoinMessage *)_message.message_object).weibo_screen_name] forState:UIControlStateNormal];
        _noteButton.userInteractionEnabled = NO;
        [self addSubview:_noteButton];
        
        y =_noteButton.frame.origin.y+_noteButton.frame.size.height;
         */
        
        GKUserButton *_avatar = [[GKUserButton alloc] initWithFrame:CGRectMake(32,y+10,40,40) useBg:NO cornerRadius:0];
        [self addSubview:_avatar];
        _avatar.user = ((GKWeiboFriendJoinMessage *)_message.message_object).recommended_user;
        
        UILabel * _nickname = [[UILabel alloc]initWithFrame:CGRectZero];
        _nickname.textColor = UIColorFromRGB(0x555555);
        _nickname.font = [UIFont fontWithName:@"Helvetica-Bold" size:13];
        _nickname.text = ((GKWeiboFriendJoinMessage*)_message.message_object).recommended_user.nickname;
        [_nickname setBackgroundColor:[UIColor clearColor]];
        [self addSubview:_nickname];
        
        UIFont *font = [UIFont fontWithName:@"Helvetica-Bold" size:13];
        CGSize labelsize = [_nickname.text sizeWithFont:font constrainedToSize:CGSizeMake(CGFLOAT_MAX, _nickname.frame.size.height) lineBreakMode:NSLineBreakByWordWrapping];
        [_nickname setFrame:CGRectMake(_avatar.frame.origin.x+_avatar.frame.size.width+5,y+15,labelsize.width, 25)];
        
        UILabel * _message_label = [[UILabel alloc]initWithFrame:CGRectMake(_nickname.frame.origin.x+_nickname.frame.size.width+5, _nickname.frame.origin.y, 120, 25)];
        _message_label.textColor = UIColorFromRGB(0x999999);
        _message_label.font = [UIFont fontWithName:@"Helvetica-Bold" size:13];
        _message_label.text = @"加入妈妈清单";
        [_message_label setBackgroundColor:[UIColor clearColor]];
        [self addSubview:_message_label];
        
        
        UIButton * avatarButton = [[UIButton alloc]initWithFrame:CGRectZero];
        [avatarButton addTarget:self action:@selector(avatarButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        avatarButton.frame = _nickname.frame;
        [self addSubview:avatarButton];

        /*
        GKFollowButton * followBTN = [[GKFollowButton alloc]initWithFrame:CGRectZero];
        [followBTN setFrame:CGRectMake(kScreenWidth-90,35, 70, 30)];
        followBTN.data = ((GKWeiboFriendJoinMessage *)_message.message_object).recommended_user;
        [self addSubview:followBTN];
         */
        

        
    }

    self.delegate = _delegate;
}




- (void)avatarButtonAction:(id)sender
{
    if (_delegate && [_delegate respondsToSelector:@selector(showUserWithUserID:)]) {
        if([_message.type isEqual:@"entity_message"])
        {
            
        }
        if([_message.type isEqual:@"entity_note_message"])
        {
            
        }
        if([_message.type isEqual:@"user_follow_message"])
        {
            [_delegate showUserWithUserID:((GKFollowerMessage*)_message.message_object).user.user_id];
        }
        if([_message.type isEqual:@"friend_joined"])
        {
            [_delegate showUserWithUserID:((GKWeiboFriendJoinMessage *)_message.message_object).recommended_user.user_id];
        }
    }
}

+ (float)height:(GKMessages *)data
{
    CGFloat y =0;
    if([data.type isEqual:@"entity_message"])
    {
        y = y+7+10+55+10;
        GKEntityMessage *entityMessage = ((GKEntityMessage*)data.message_object);
        if(entityMessage.added_to_selection)
        {
            y = y+22;
        }
        
        if([entityMessage.liker_id_list count]>0)
        {
            y = y+22;
        }
        
        if([entityMessage.note_id_list count]>0)
        {
            y = y+22;
        }
    }
    if([data.type isEqual:@"user_follow_message"])
    {
        y = 74;
    }
    if([data.type isEqual:@"friend_joined"])
    {
        y = 60;
    }
    
    if([data.type isEqual:@"post_entity_note"])
    {
        GKNoteMessage *noteMessage = ((GKNoteMessage*)data.message_object);
        y = 200;

    }
    return y;
}
- (void)rtLabel:(id)rtLabel didSelectLinkWithURL:(NSURL*)url
{
	NSLog(@"did select url %@", url);
}

@end
