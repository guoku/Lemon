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
    if([_message.type isEqual:@"entity_message"])
    {
        CGFloat y = 6;
    
        GKEntityMessage *entityMessage = ((GKEntityMessage*)_message.message_object);
        if(entityMessage.added_to_selection)
        {
            UIButton *_selectionButton = [[UIButton alloc]initWithFrame:CGRectMake(8, y+9, 250, 14)];
            [_selectionButton.titleLabel setFont:[UIFont fontWithName:@"Helvetica" size:13.0f]];
            [_selectionButton setTitleColor:UIColorFromRGB(0x666666) forState:UIControlStateNormal];
            [_selectionButton setImage:[UIImage imageNamed:@"message_icon_selection.png"] forState:UIControlStateNormal];
            [_selectionButton setTitle:@"你添加的商品，已被收录精选" forState:UIControlStateNormal];
            [_selectionButton.titleLabel setTextAlignment:NSTextAlignmentLeft];
            _selectionButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
            [_selectionButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 7, 0, 0)];
            _selectionButton.userInteractionEnabled = NO;
            [self addSubview:_selectionButton];
            
            y = _selectionButton.frame.origin.y+_selectionButton.frame.size.height;
        }
        if([entityMessage.liker_id_list count]>0)
        {
            UIButton *_likeCountButton = [[UIButton alloc]initWithFrame:CGRectMake(8, y+9, 250, 14)];
            [_likeCountButton.titleLabel setFont:[UIFont fontWithName:@"Helvetica" size:13.0f]];
            [_likeCountButton setTitleColor:UIColorFromRGB(0x666666) forState:UIControlStateNormal];
            [_likeCountButton setImage:[UIImage imageNamed:@"message_icon_like.png"] forState:UIControlStateNormal];
            [_likeCountButton setTitle:[NSString stringWithFormat:@"你添加的商品收到 %u 个喜爱",[entityMessage.liker_id_list count]]forState:UIControlStateNormal];
            [_likeCountButton.titleLabel setTextAlignment:NSTextAlignmentLeft];
            _likeCountButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
            [_likeCountButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 7, 0, 0)];
            _likeCountButton.userInteractionEnabled = NO;
            [self addSubview:_likeCountButton];
            
            y = _likeCountButton.frame.origin.y+_likeCountButton.frame.size.height;
        }
        if([entityMessage.note_id_list count]>0)
        {
            UIButton *_noteCountButton = [[UIButton alloc]initWithFrame:CGRectMake(8, y+9, 250, 14)];
            [_noteCountButton.titleLabel setFont:[UIFont fontWithName:@"Helvetica" size:13.0f]];
            [_noteCountButton setTitleColor:UIColorFromRGB(0x666666) forState:UIControlStateNormal];
            [_noteCountButton setImage:[UIImage imageNamed:@"message_icon_note.png"] forState:UIControlStateNormal];
            [_noteCountButton setTitle:[NSString stringWithFormat:@"你添加的商品收到 %u 条点评",[entityMessage.note_id_list count]] forState:UIControlStateNormal];
            [_noteCountButton.titleLabel setTextAlignment:NSTextAlignmentLeft];
            _noteCountButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
            [_noteCountButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 7, 0, 0)];
            _noteCountButton.userInteractionEnabled = NO;
            [self addSubview:_noteCountButton];
            
            y = _noteCountButton.frame.origin.y+_noteCountButton.frame.size.height;
        }

        GKItemButton *_img = [[GKItemButton alloc] init];
        [_img setType:kItemButtonWithNumProgress];
        [_img setPadding:4];
        [_img setFrame:CGRectMake(32, y+10, 55, 55)];
        [self addSubview:_img];
        _img.entity=entityMessage.entity;

    }
    if([_message.type isEqual:@"entity_note_message"])
    {
        CGFloat y = 6;
        
        GKNoteMessage *noteMessage = ((GKNoteMessage*)_message.message_object);
        if([noteMessage.comment_id_list count]>0)
        {
            UIButton *_notePokeButton = [[UIButton alloc]initWithFrame:CGRectMake(8, y+9, 250, 14)];
            [_notePokeButton.titleLabel setFont:[UIFont fontWithName:@"Helvetica" size:13.0f]];
            [_notePokeButton setTitleColor:UIColorFromRGB(0x666666) forState:UIControlStateNormal];
            [_notePokeButton setImage:[UIImage imageNamed:@"message_icon_note.png"] forState:UIControlStateNormal];
            [_notePokeButton setTitle:[NSString stringWithFormat:@"你的点评收到 %u 个评论",[noteMessage.comment_id_list count]] forState:UIControlStateNormal];
            [_notePokeButton.titleLabel setTextAlignment:NSTextAlignmentLeft];
            _notePokeButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
            [_notePokeButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 7, 0, 0)];
            _notePokeButton.userInteractionEnabled = NO;
            [self addSubview:_notePokeButton];
            
            y = _notePokeButton.frame.origin.y+_notePokeButton.frame.size.height;
        }
        if([noteMessage.poker_id_list count]>0)
        {
            UIButton *_notePokeButton = [[UIButton alloc]initWithFrame:CGRectMake(8, y+9, 250, 14)];
            [_notePokeButton.titleLabel setFont:[UIFont fontWithName:@"Helvetica" size:13.0f]];
            [_notePokeButton setTitleColor:UIColorFromRGB(0x666666) forState:UIControlStateNormal];
            [_notePokeButton setImage:[UIImage imageNamed:@"message_icon_poke.png"] forState:UIControlStateNormal];
            [_notePokeButton setTitle:[NSString stringWithFormat:@"你的点评收到 %u 个赞",[noteMessage.poker_id_list count]] forState:UIControlStateNormal];
            [_notePokeButton.titleLabel setTextAlignment:NSTextAlignmentLeft];
            _notePokeButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
            [_notePokeButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 7, 0, 0)];
            _notePokeButton.userInteractionEnabled = NO;
            [self addSubview:_notePokeButton];
            
            y = _notePokeButton.frame.origin.y+_notePokeButton.frame.size.height;
        }
        if([noteMessage.hooter_id_list count]>0)
        {
            UIButton *_notePokeButton = [[UIButton alloc]initWithFrame:CGRectMake(8, y+9, 250, 14)];
            [_notePokeButton.titleLabel setFont:[UIFont fontWithName:@"Helvetica" size:13.0f]];
            [_notePokeButton setTitleColor:UIColorFromRGB(0x666666) forState:UIControlStateNormal];
            [_notePokeButton setImage:[UIImage imageNamed:@"message_icon_hoot.png"] forState:UIControlStateNormal];
            [_notePokeButton setTitle:[NSString stringWithFormat:@"你的点评收到 %u 个踩",[noteMessage.hooter_id_list count]] forState:UIControlStateNormal];
            [_notePokeButton.titleLabel setTextAlignment:NSTextAlignmentLeft];
            _notePokeButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
            [_notePokeButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 7, 0, 0)];
            _notePokeButton.userInteractionEnabled = NO;
            [self addSubview:_notePokeButton];
            
            y = _notePokeButton.frame.origin.y+_notePokeButton.frame.size.height;
        }

        
        GKItemButton *_img = [[GKItemButton alloc] init];
        [_img setType:kItemButtonWithNumProgress];
        [_img setPadding:4];
        [_img setFrame:CGRectMake(32, y+10, 55, 55)];
        [self addSubview:_img];
        _img.note = noteMessage.note;

    }
    if([_message.type isEqual:@"user_follow_message"])
    {
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

        GKUserButton *_avatar = [[GKUserButton alloc] initWithFrame:CGRectMake(32,y+10,25,25)];
        [self addSubview:_avatar];
        _avatar.user = ((GKFollowerMessage*)_message.message_object).user;
        
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
        
        GKFollowButton * followBTN = [[GKFollowButton alloc]initWithFrame:CGRectZero];
        [followBTN setFrame:CGRectMake(kScreenWidth-90,35, 70, 30)];
        followBTN.data = ((GKFollowerMessage*)_message.message_object).user;
        [self addSubview:followBTN];
        
    }
    if([_message.type isEqual:@"friend_joined"])
    {
        CGFloat y = 6;
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
        
        GKUserButton *_avatar = [[GKUserButton alloc] initWithFrame:CGRectMake(32,y+10,25,25)];
        [self addSubview:_avatar];
        _avatar.user = ((GKWeiboFriendJoinMessage *)_message.message_object).recommended_user;
        
        UILabel * _nickname = [[UILabel alloc]initWithFrame:CGRectZero];
        _nickname.textColor = UIColorFromRGB(0x666666);
        _nickname.font = [UIFont fontWithName:@"Helvetica" size:13];
        _nickname.text = ((GKWeiboFriendJoinMessage*)_message.message_object).recommended_user.nickname;
        [_nickname setBackgroundColor:[UIColor clearColor]];
        [self addSubview:_nickname];
        
        UIFont *font = [UIFont fontWithName:@"Helvetica" size:13];
        CGSize labelsize = [_nickname.text sizeWithFont:font constrainedToSize:CGSizeMake(CGFLOAT_MAX, _nickname.frame.size.height) lineBreakMode:NSLineBreakByWordWrapping];
        [_nickname setFrame:CGRectMake(63,y+10,labelsize.width, 25)];
        UIButton * avatarButton = [[UIButton alloc]initWithFrame:CGRectZero];
        [avatarButton addTarget:self action:@selector(avatarButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        avatarButton.frame = _nickname.frame;
        [self addSubview:avatarButton];
        
        GKFollowButton * followBTN = [[GKFollowButton alloc]initWithFrame:CGRectZero];
        [followBTN setFrame:CGRectMake(kScreenWidth-90,35, 70, 30)];
        followBTN.data = ((GKWeiboFriendJoinMessage *)_message.message_object).recommended_user;
        [self addSubview:followBTN];
        
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
    if([data.type isEqual:@"weibo_friend_notification_message"])
    {
        y = 74;
    }
    
    if([data.type isEqual:@"entity_note_message"])
    {
        {
            y = y+7+10+55+10;
            GKNoteMessage *noteMessage = ((GKNoteMessage*)data.message_object);
            if([noteMessage.hooter_id_list count]>0)
            {
                y = y+22;
            }
            if([noteMessage.poker_id_list count]>0)
            {
                y = y+22;
            }
            if([noteMessage.comment_id_list count]>0)
            {
                y = y+22;
            }
        }
    }
    return y;
}

@end
