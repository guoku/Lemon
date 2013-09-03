//
//  TableViewCellForMessage.m
//  Grape
//
//  Created by huiter on 14-4-19.
//  Copyright (c) 2014年 guoku. All rights reserved.
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
#import "RatingView.h"
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
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    if(selected)
    {
        [self viewWithTag:4003].hidden = YES;
        self.backgroundColor = UIColorFromRGB(0xededed);
    }
    else
    {
        [self viewWithTag:4003].hidden = NO;
        self.backgroundColor = UIColorFromRGB(0xf9f9f9);
    }
    // Configure the view for the selected state
}
- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    [super setHighlighted:highlighted animated:animated];
    if(highlighted)
    {
        [self viewWithTag:4003].hidden = YES;
        self.backgroundColor = UIColorFromRGB(0xededed);
    }
    else
    {
        [self viewWithTag:4003].hidden = NO;
        self.backgroundColor = UIColorFromRGB(0xf9f9f9);
    }
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
    UIImageView * icon = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 22, 22)];


    UIImageView * _seperatorLineImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, self.frame.size.height - 2, kScreenWidth, 2)];
    _seperatorLineImageView.tag = 4003;
    [_seperatorLineImageView setImage:[UIImage imageNamed:@"splitline.png"]];
    [self addSubview:_seperatorLineImageView];
    
    UIButton *_time = [[UIButton alloc]initWithFrame:CGRectMake(55, self.frame.size.height-15, 60, 10)];
    //[_time setImage:[UIImage imageNamed:@"icon_clock"] forState:UIControlStateNormal];
    [_time.titleLabel setFont:[UIFont fontWithName:@"Helvetica" size:10.0f]];
    [_time setTitleColor:UIColorFromRGB(0xb8b8b8) forState:UIControlStateNormal];
    [_time.titleLabel setTextAlignment:NSTextAlignmentLeft];
    //[_time setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 2)];
    _time.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    _time.userInteractionEnabled = NO;
    [_time setTitle:[NSDate stringFromDate:_message.created_time WithFormatter:@"MM-dd HH:mm"] forState:UIControlStateNormal];
    [self addSubview:_time];

    if([_message.type isEqual:@"post_entity_note"])
    {
        icon.image = [UIImage imageNamed:@"message_icon5.png"];
        CGFloat y = 0;
        
        GKNoteMessage *message = ((GKNoteMessage*)_message.message_object);
        
        GKUserButton *_avatar = [[GKUserButton alloc] initWithFrame:CGRectMake(10,y+10,40,40) useBg:NO cornerRadius:2];
        [self addSubview:_avatar];
        _avatar.userBase = message.user;
        
        RTLabel * message_label = [[RTLabel alloc]initWithFrame:CGRectMake(60,y+10,165,100)];
        [message_label setParagraphReplacement:@""];
        
        message_label.lineSpacing = 4.0;
        message_label.delegate = self;
        
        [message_label setText:[NSString stringWithFormat:@"<a href='user:%u'><font face='Helvetica-Bold' color='#555555' size=14>%@</font></a><font face='Helvetica' color='#999999' size=14><br>点评了 </font><a href='entity:%u'><font face='Helvetica' color='#555555' size=14>%@</font></a>",message.user.user_id,message.user.nickname,message.entity.entity_id,message.entity.title]];
        
        CGSize optimumSize = [message_label optimumSize];
        CGRect frame = [message_label frame];
        frame.size.height = (int)optimumSize.height+5;
        
        [message_label setFrame:CGRectMake(message_label.frame.origin.x, message_label.frame.origin.y, 165, frame.size.height)];
        
        [self addSubview:message_label];
        
        RatingView *_ratingView = [[RatingView alloc]initWithFrame:CGRectZero];
        [_ratingView setImagesDeselected:@"star_s.png" partlySelected:@"star_s_half.png" fullSelected:@"star_s_full.png" andDelegate:nil];
        _ratingView.frame = CGRectMake(50, message_label.frame.size.height + message_label.frame.origin.y,80 ,20);
        [_ratingView displayRating:message.entity.my_score/2];
        _ratingView.userInteractionEnabled = NO;
        //[self addSubview:_ratingView];
        
        GKItemButton *_img = [[GKItemButton alloc] init];
        [_img setType:kItemButtonWithNumProgress];
        [_img setPadding:4];
        [_img setFrame:CGRectMake(230, y+10, 80, 80)];
        [self addSubview:_img];
        _img.entityBase = message .entity;

    }
    if([_message.type isEqual:@"following"])
    {
        icon.image = [UIImage imageNamed:@"message_icon2.png"];
        CGFloat y = 0;
        GKUserButton *_avatar = [[GKUserButton alloc] initWithFrame:CGRectMake(10,y+10,40,40) useBg:NO cornerRadius:2];
        [self addSubview:_avatar];
        _avatar.user = ((GKFollowerMessage*)_message.message_object).user;
      
        UILabel * _nickname = [[UILabel alloc]initWithFrame:CGRectZero];
        _nickname.textColor = UIColorFromRGB(0x555555);
        _nickname.font = [UIFont fontWithName:@"Helvetica-Bold" size:14];
        _nickname.text = ((GKFollowerMessage*)_message.message_object).user.nickname;
        [_nickname setBackgroundColor:[UIColor clearColor]];
        [self addSubview:_nickname];
        
        UIFont *font = [UIFont fontWithName:@"Helvetica-Bold" size:14];
        CGSize labelsize = [_nickname.text sizeWithFont:font constrainedToSize:CGSizeMake(CGFLOAT_MAX, _nickname.frame.size.height) lineBreakMode:NSLineBreakByWordWrapping];
        [_nickname setFrame:CGRectMake(_avatar.frame.origin.x+_avatar.frame.size.width+10,y+15,labelsize.width, 25)];
        
        UILabel * _message_label = [[UILabel alloc]initWithFrame:CGRectMake(_nickname.frame.origin.x+_nickname.frame.size.width+5, _nickname.frame.origin.y, 120, 25)];
        _message_label.textColor = UIColorFromRGB(0x999999);
        _message_label.font = [UIFont fontWithName:@"Helvetica-Bold" size:14];
        _message_label.text = @"关注了你";
        [_message_label setBackgroundColor:[UIColor clearColor]];
        [self addSubview:_message_label];
  
        
        GKFollowButton * followBTN = [[GKFollowButton alloc]initWithFrame:CGRectZero];
        [followBTN setFrame:CGRectMake(kScreenWidth-84,15, 70, 30)];
        followBTN.data = ((GKFollowerMessage*)_message.message_object).user;
        [self addSubview:followBTN];
        
    }
    if([_message.type isEqual:@"friend_joined"])
    {
        icon.image = [UIImage imageNamed:@"message_icon2.png"];
        CGFloat y = 0;
        
        GKUserButton *_avatar = [[GKUserButton alloc] initWithFrame:CGRectMake(10,y+10,40,40) useBg:NO cornerRadius:2];
        [self addSubview:_avatar];
        _avatar.user = ((GKWeiboFriendJoinMessage *)_message.message_object).recommended_user;
        
        UILabel * _nickname = [[UILabel alloc]initWithFrame:CGRectZero];
        _nickname.textColor = UIColorFromRGB(0x555555);
        _nickname.font = [UIFont fontWithName:@"Helvetica-Bold" size:14];
        _nickname.text = ((GKWeiboFriendJoinMessage*)_message.message_object).recommended_user.nickname;
        [_nickname setBackgroundColor:[UIColor clearColor]];
        [self addSubview:_nickname];
        
        UIFont *font = [UIFont fontWithName:@"Helvetica-Bold" size:14];
        CGSize labelsize = [_nickname.text sizeWithFont:font constrainedToSize:CGSizeMake(CGFLOAT_MAX, _nickname.frame.size.height) lineBreakMode:NSLineBreakByWordWrapping];
        [_nickname setFrame:CGRectMake(_avatar.frame.origin.x+_avatar.frame.size.width+10,y+15,labelsize.width, 25)];
        
        UILabel * _message_label = [[UILabel alloc]initWithFrame:CGRectMake(_nickname.frame.origin.x+_nickname.frame.size.width+5, _nickname.frame.origin.y, 120, 25)];
        _message_label.textColor = UIColorFromRGB(0x999999);
        _message_label.font = [UIFont fontWithName:@"Helvetica-Bold" size:14];
        _message_label.text = @"加入妈妈清单";
        [_message_label setBackgroundColor:[UIColor clearColor]];
        [self addSubview:_message_label];
        
        
        UIButton * avatarButton = [[UIButton alloc]initWithFrame:CGRectZero];
        [avatarButton addTarget:self action:@selector(avatarButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        avatarButton.frame = _nickname.frame;
        [self addSubview:avatarButton];
    }
    if([_message.type isEqual:@"poke_note"])
    {
        icon.image = [UIImage imageNamed:@"message_icon3.png"];
        CGFloat y = 0;
        
        GKNoteMessage *message = ((GKNoteMessage*)_message.message_object);
        
        GKUserButton *_avatar = [[GKUserButton alloc] initWithFrame:CGRectMake(10,y+10,40,40) useBg:NO cornerRadius:2];
        [self addSubview:_avatar];
        _avatar.userBase = message.user;
        
        RTLabel * message_label = [[RTLabel alloc]initWithFrame:CGRectMake(60,y+10,165,100)];
        [message_label setParagraphReplacement:@""];
        
        message_label.lineSpacing = 4.0;
        message_label.delegate = self;
        
        [message_label setText:[NSString stringWithFormat:@"<a href='user:%u'><font face='Helvetica-Bold' color='#555555' size=14>%@</font></a><font face='Helvetica' color='#999999' size=14><br>顶了你对 </font><a href='entity:%u'><font face='Helvetica' color='#555555' size=14>%@</font></a><font face='Helvetica' color='#999999' size=14> 的点评</font>",message.user.user_id,message.user.nickname,message.entity.entity_id,message.entity.title]];
        
        [self addSubview:message_label];
        
        GKItemButton *_img = [[GKItemButton alloc] init];
        [_img setType:kItemButtonWithNumProgress];
        [_img setPadding:4];
        [_img setFrame:CGRectMake(230, y+10, 80, 80)];
        [self addSubview:_img];
        _img.entityBase = message .entity;
    }
    if([_message.type isEqual:@"reply"])
    {
        icon.image = [UIImage imageNamed:@"message_icon4.png"];
        CGFloat y = 0;
        
        GKNoteMessage *message = ((GKNoteMessage*)_message.message_object);
        
        GKUserButton *_avatar = [[GKUserButton alloc] initWithFrame:CGRectMake(10,y+10,40,40) useBg:NO cornerRadius:2];
        [self addSubview:_avatar];
        _avatar.userBase = message.user;
        
        RTLabel * message_label = [[RTLabel alloc]initWithFrame:CGRectMake(60,y+10,165,100)];
        [message_label setParagraphReplacement:@""];
        
        message_label.lineSpacing = 4.0;
        message_label.delegate = self;
        
       [message_label setText:[NSString stringWithFormat:@"<a href='user:%u'><font face='Helvetica-Bold' color='#555555' size=14>%@</font></a><font face='Helvetica' color='#999999' size=14><br>回复了你对 </font><a href='entity:%u'><font face='Helvetica' color='#555555' size=14>%@</font></a><font face='Helvetica' color='#999999' size=14> 的点评</font>",message.user.user_id,message.user.nickname,message.entity.entity_id,message.entity.title]];
        
        [self addSubview:message_label];
        
        GKItemButton *_img = [[GKItemButton alloc] init];
        [_img setType:kItemButtonWithNumProgress];
        [_img setPadding:4];
        [_img setFrame:CGRectMake(230, y+10, 80, 80)];
        [self addSubview:_img];
        _img.entityBase = message .entity;
    }
    icon.center = CGPointMake(46,46);
    [self addSubview:icon];

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
        if([_message.type isEqual:@"follwing"])
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
    if([data.type isEqual:@"post_entity_note"])
    {
        y = 100;
        /*
        GKNoteMessage *message = ((GKNoteMessage*)data.message_object);
        
        RTLabel * message_label = [[RTLabel alloc]initWithFrame:CGRectMake(50,y+15,200,100)];
        [message_label setParagraphReplacement:@""];
        
        message_label.lineSpacing = 4.0;
        
        [message_label setText:[NSString stringWithFormat:@"<a href='user:%u'><font face='Helvetica-Bold' color='#555555' size=14>%@</font></a><font face='Helvetica' color='#999999' size=14> 点评了 </font><a href='entity:%u'><font face='Helvetica-Bold' color='#555555' size=14>%@</font></a>",message.user.user_id,message.user.nickname,message.entity.entity_id,message.entity.title]];
        
        CGSize optimumSize = [message_label optimumSize];
        y = (int)optimumSize.height+30;
         */
        
    }
    if([data.type isEqual:@"following"])
    {
        y = 70;
    }
    if([data.type isEqual:@"friend_joined"])
    {
        y = 70;
    }
    if([data.type isEqual:@"poke_note"])
    {
        y = 100;
        /*
        GKNoteMessage *message = ((GKNoteMessage*)data.message_object);
        
        RTLabel * message_label = [[RTLabel alloc]initWithFrame:CGRectMake(50,y+15,200,100)];
        [message_label setParagraphReplacement:@""];
        
        message_label.lineSpacing = 4.0;
      
        [message_label setText:[NSString stringWithFormat:@"<a href='user:%u'><font face='Helvetica-Bold' color='#555555' size=14>%@</font></a><font face='Helvetica' color='#999999' size=14> 顶了你对 </font><a href='entity:%u'><font face='Helvetica-Bold' color='#555555' size=14>%@</font></a><font face='Helvetica' color='#999999' size=14> 的点评</font>",message.user.user_id,message.user.nickname,message.entity.entity_id,message.entity.title]];
        
        CGSize optimumSize = [message_label optimumSize];
        y = (int)optimumSize.height+25;
         */
    }
    if([data.type isEqual:@"reply"])
    {
        y = 100;
        /*
        GKNoteMessage *message = ((GKNoteMessage*)data.message_object);
        
        RTLabel * message_label = [[RTLabel alloc]initWithFrame:CGRectMake(50,y+15,200,100)];
        [message_label setParagraphReplacement:@""];
        
        message_label.lineSpacing = 4.0;

        
        [message_label setText:[NSString stringWithFormat:@"<a href='user:%u'><font face='Helvetica-Bold' color='#555555' size=14>%@</font></a><font face='Helvetica' color='#999999' size=14> 回复了你对 </font><a href='entity:%u'><font face='Helvetica-Bold' color='#555555' size=14>%@</font></a><font face='Helvetica' color='#999999' size=14> 的点评</font>",message.user.user_id,message.user.nickname,message.entity.entity_id,message.entity.title]];
        
        CGSize optimumSize = [message_label optimumSize];
        y = (int)optimumSize.height+25;
         */
        
    }

    return y;
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
