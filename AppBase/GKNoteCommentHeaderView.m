//
//  GKNoteCommentHeaderView.m
//  Grape
//
//  Created by huiter on 13-3-30.
//  Copyright (c) 2013年 guoku. All rights reserved.
//

#import "GKNoteCommentHeaderView.h"
#import "NSDate+GKHelper.h"
@implementation GKNoteCommentHeaderView
{
@private
    __strong GKNote * _noteData;
    CGFloat _y;
}
@synthesize noteData = _noteData;
@synthesize nickname = _nickname;
@synthesize note = _note;
@synthesize time = _time;
@synthesize avatar = _avatar;
@synthesize avatarButton = _avatarButton;
@synthesize commentButton = _commentButton;
@synthesize bg = _bg;
@synthesize seperatorLineImageView = _seperatorLineImageView ;


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.bg = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0,kScreenWidth-16, 100)];
        [self addSubview:_bg];
        
        self.avatar = [[GKUserButton alloc ]initWithFrame:CGRectZero];
        [_avatar setFrame:CGRectMake(9, 13, 35, 35)];
        [self addSubview:_avatar];
                
        self.nickname = [[UILabel alloc]initWithFrame:CGRectMake(50, 10, 120, 20)];
        _nickname.textColor = UIColorFromRGB(0x666666);
        _nickname.font = [UIFont fontWithName:@"Helvetica-Bold" size:12];
        [_nickname setBackgroundColor:[UIColor clearColor]];
        [self addSubview:_nickname];
        
        self.time = [[UIButton alloc]initWithFrame:CGRectMake(170, 10,125, 20)];
        [_time setImage:[UIImage imageNamed:@"icon_clock"] forState:UIControlStateNormal];
        [_time.titleLabel setFont:[UIFont fontWithName:@"Helvetica" size:9.0f]];
        [_time setTitleColor:UIColorFromRGB(0x999999) forState:UIControlStateNormal];
        [_time.titleLabel setTextAlignment:NSTextAlignmentLeft];
        [_time setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 2)];
        _time.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        _time.userInteractionEnabled = NO;
        [self addSubview:_time];
        
        self.note = [[GKNoteLabel alloc]initWithFrame:CGRectMake(50,32, 250, 400)];
        [_note.content setVerticalAlignment:TTTAttributedLabelVerticalAlignmentTop];
        _note.content.font = [UIFont fontWithName:@"STHeitiSC-Light" size:13];
        _note.content.numberOfLines = 0;
        _note.content.leading = 2;
        _note.content.lineBreakMode = NSLineBreakByWordWrapping;
        [_note setFontsize:13];
        [self addSubview:_note];
        
        self.avatarButton = [[UIButton alloc]initWithFrame:_nickname.frame];
        [_avatarButton addTarget:self action:@selector(avatarButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_avatarButton];
        
        self.commentButton = [[UIButton alloc]initWithFrame:CGRectZero];
        [_commentButton addTarget:self action:@selector(commentButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [_commentButton setImage:[UIImage imageNamed:@"icon_comment"] forState:UIControlStateNormal];
        [_commentButton.titleLabel setFont:[UIFont fontWithName:@"Helvetica" size:12.0f]];
        [_commentButton setTitleColor:UIColorFromRGB(0x666666) forState:UIControlStateNormal];
        [_commentButton setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 8)];
        [_commentButton.titleLabel setTextAlignment:NSTextAlignmentLeft];
        _commentButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        _commentButton.userInteractionEnabled = NO;
        [self addSubview:_commentButton];
        
        self.seperatorLineImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _seperatorLineImageView.backgroundColor = UIColorFromRGB(0xf2f2f2);
        [self addSubview:_seperatorLineImageView];
        
    }
    return self;
}

- (void)setNoteData:(GKNote *)noteData
{
    if ([noteData isKindOfClass:[GKNote class]]) {
        _noteData = noteData;
    }
    
    [self setNeedsLayout];
}
- (void)setDelegate:(id<GKDelegate>)delegate
{
    _delegate = delegate;
    _note.gkdelegate = _delegate;
}

- (void)avatarButtonAction:(id)sender
{
    if (_delegate && [_delegate respondsToSelector:@selector(showUserWithUserID:)]) {
        [_delegate showUserWithUserID:_noteData.creator.user_id];
    }
}


#pragma mark -
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.frame = CGRectMake(8, 0, kScreenWidth-16, self.frame.size.height);
    self.bg.frame = CGRectMake(0, 0,kScreenWidth-16 ,self.frame.size.height );
    self.bg.image = [[UIImage imageNamed:@"comment_header_note_bg.png"] stretchableImageWithLeftCapWidth:10 topCapHeight:5];

    self.avatar.userBase = _noteData.creator;
    
    [self.nickname setText:_noteData.creator.nickname];
    
    
    [_time setTitle:[NSDate stringFromDate:_noteData.created_time WithFormatter:@"yyyy-MM-dd HH:mm"] forState:UIControlStateNormal];
    
    UIFont *font = [UIFont fontWithName:@"STHeitiSC-Light" size:13];
    CGSize size = [_noteData.note sizeWithFont:font constrainedToSize:CGSizeMake(240, CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping];
    [_note setFrame:CGRectMake(_note.frame.origin.x, _note.frame.origin.y, 240, size.height+10)];
    _note.note = _noteData;

    self.seperatorLineImageView.frame = CGRectMake(0,self.frame.size.height-30, kScreenWidth-16, 1);
    
    NSString * comment_count = [NSString stringWithFormat:@"%u", _noteData.comment_count];
    [_commentButton setTitle:comment_count forState:UIControlStateNormal];
    [_commentButton setFrame:CGRectMake(0, self.frame.size.height-30, kScreenWidth-16, 30)];
 
}
+ (float)height:(GKNote *)data
{
    UIFont *font = [UIFont fontWithName:@"STHeitiSC-Light" size:13];
    
    CGSize size = [data.note sizeWithFont:font constrainedToSize:CGSizeMake(240, CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping];
    
    return size.height + 75; // 10即消息上下的空间，可自由调整
}
@end
