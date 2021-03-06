//
//  GKDetailNoteView.m
//  Grape
//
//  Created by huiter on 13-3-22.
//  Copyright (c) 2013年 guoku. All rights reserved.
//

#import "GKDetailNoteCellView.h"
#import "NSDate+GKHelper.h"
#import "GKNote.h"
#import "GKAppDelegate.h"

@implementation GKDetailNoteCellView{
@private
    UIImageView *_seperatorLineImageView;
    __strong GKNote * _noteData;
    CGFloat y;
}
@synthesize noteData = _noteData;
@synthesize nickname = _nickname;
@synthesize seperatorLineImageView = _seperatorLineImageView;
@synthesize note = _note;
@synthesize time = _time;
@synthesize avatar = _avatar;
@synthesize pokeButton = _pokeButton;
@synthesize commentButton = _commentButton;
@synthesize avatarButton = _avatarButton;
@synthesize delegate = _delegate;
@synthesize notedelegate = _notedelegate;
@synthesize ratingView = _ratingView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.avatar = [[GKUserButton alloc]initWithFrame:CGRectZero useBg:NO cornerRadius:2];
        [_avatar setFrame:CGRectMake(6, 7, 40, 40)];
        [self addSubview:_avatar];
        
        self.nickname = [[UILabel alloc]initWithFrame:CGRectMake(53, 10, 240, 15)];
        _nickname.textColor = UIColorFromRGB(0x555555);
        _nickname.font = [UIFont fontWithName:@"Helvetica-Bold" size:14];
        [_nickname setBackgroundColor:[UIColor clearColor]];
        [self addSubview:_nickname];
        
        y = _nickname.frame.origin.y + _nickname.frame.size.height;
        
        _ratingView = [[RatingView alloc]initWithFrame:CGRectZero];
        [_ratingView setImagesDeselected:@"star_s.png" partlySelected:@"star_s_half.png" fullSelected:@"star_s_full.png" andDelegate:nil];
        _ratingView.center = CGPointMake(_ratingView.center.x, 23);
        _ratingView.userInteractionEnabled = NO;
        [self addSubview:_ratingView];
        
        self.note = [[UILabel alloc]initWithFrame:CGRectMake(50,y,240,400)];
        _note.font = [UIFont fontWithName:@"Helvetica" size:14];
        _note.numberOfLines = 0;
        _note.textAlignment = NSTextAlignmentLeft;
        _note.textColor = UIColorFromRGB(0x777777);
        _note.backgroundColor = [UIColor clearColor];
        _note.lineBreakMode = NSLineBreakByWordWrapping;
        [self addSubview:_note];
        
        self.avatarButton = [[UIButton alloc]initWithFrame:CGRectZero];
        [_avatarButton addTarget:self action:@selector(avatarButtonAction:) forControlEvents:UIControlEventTouchUpInside];        
        [self addSubview:_avatarButton];

        
        _pokeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_pokeButton addTarget:self action:@selector(pokeButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [_pokeButton setImage:[UIImage imageNamed:@"poke.png"] forState:UIControlStateNormal];
        [_pokeButton setImage:[UIImage imageNamed:@"poke.png"] forState:UIControlStateHighlighted|UIControlStateNormal];
        [_pokeButton setImage:[UIImage imageNamed:@"poked.png"] forState:UIControlStateSelected];
        [_pokeButton setImage:[UIImage imageNamed:@"poked.png"] forState:UIControlStateSelected|UIControlStateHighlighted];
        [_pokeButton setBackgroundImage:[[UIImage imageNamed:@"button_normal.png"] stretchableImageWithLeftCapWidth:10 topCapHeight:10]  forState:UIControlStateNormal];
        [_pokeButton setBackgroundImage:[[UIImage imageNamed:@"button_normal_press.png"] stretchableImageWithLeftCapWidth:10 topCapHeight:10]  forState:UIControlStateNormal|UIControlStateHighlighted];
        [_pokeButton setBackgroundImage:[[UIImage imageNamed:@"button_normal.png"] stretchableImageWithLeftCapWidth:10 topCapHeight:10]  forState:UIControlStateSelected];
        [_pokeButton setBackgroundImage:[[UIImage imageNamed:@"button_normal_press.png"] stretchableImageWithLeftCapWidth:10 topCapHeight:10]  forState:UIControlStateSelected|UIControlStateHighlighted];
        [_pokeButton.titleLabel setFont:[UIFont fontWithName:@"Helvetica" size:12.0f]];
        [_pokeButton setTitleColor:UIColorFromRGB(0x666666) forState:UIControlStateNormal];
        [_pokeButton.titleLabel setTextAlignment:NSTextAlignmentLeft];
        _pokeButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        [_pokeButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 8, 0, 0)];
        [self addSubview:_pokeButton];
        
        
        
        self.commentButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_commentButton addTarget:self action:@selector(commentButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [_commentButton setImage:[UIImage imageNamed:@"icon_comment"] forState:UIControlStateNormal];
        [_commentButton setBackgroundImage:[UIImage imageNamed:@"detail_cell_button.png"]  forState:UIControlStateNormal];
        [_commentButton.titleLabel setFont:[UIFont fontWithName:@"Helvetica" size:12.0f]];
        [_commentButton setTitleColor:UIColorFromRGB(0x666666) forState:UIControlStateNormal];
        [_commentButton.titleLabel setTextAlignment:NSTextAlignmentLeft];
        _commentButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        [_commentButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 8, 0, 0)];
        _commentButton.userInteractionEnabled = NO;
        //[self addSubview:_commentButton];

        self.time = [[UIButton alloc]initWithFrame:CGRectZero];
        [_time setImage:[UIImage imageNamed:@"icon_clock"] forState:UIControlStateNormal];
        [_time.titleLabel setFont:[UIFont fontWithName:@"Helvetica" size:9.0f]];
        [_time setTitleColor:UIColorFromRGB(0x666666) forState:UIControlStateNormal];
        [_time.titleLabel setTextAlignment:NSTextAlignmentLeft];
        [_time setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 2)];
        _time.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        _time.userInteractionEnabled = NO;
        [self addSubview:_time];
        
        _seperatorLineImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        //[_seperatorLineImageView setImage:[UIImage imageNamed:@"splitline.png"]];
        _seperatorLineImageView.backgroundColor = [UIColor colorWithRed:238.0f / 255.0f green:238.0f / 255.0f blue:238.0 / 255.0f alpha:1.0f]
;
        [self addSubview:_seperatorLineImageView];
        
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
        self.backgroundColor = UIColorFromRGB(0xffffff);
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
        self.backgroundColor = UIColorFromRGB(0xffffff);
    }
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
    _avatar.delegate = _delegate;
}
#pragma mark - layout view
- (void)layoutSubviews
{
    [super layoutSubviews];
    self.backgroundColor = [UIColor whiteColor];
    
    self.backgroundView.frame = CGRectMake(0, 0, kScreenWidth, self.frame.size.height);
    
    self.avatar.creator = _noteData.creator;
    
    [self.nickname setText:[NSString stringWithFormat:@"%@ :",_noteData.creator.nickname]];
    
    UIFont *font = [UIFont fontWithName:@"Helvetica-Bold" size:14];
    CGSize size = [self.nickname.text sizeWithFont:font constrainedToSize:CGSizeMake(250, CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping];
    self.nickname.frame = CGRectMake(50, 8, size.width, size.height);
    
    _ratingView.frame = CGRectMake(52+size.width, 12,80 ,size.height);
    [_ratingView displayRating:_noteData.score/2];
    
    font = [UIFont fontWithName:@"Helvetica" size:14];
    size = [_noteData.note sizeWithFont:font constrainedToSize:CGSizeMake(240, CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping];
    GKLog(@"%@",NSStringFromCGSize(size));
    [_note setFrame:CGRectMake(_note.frame.origin.x, _note.frame.origin.y, 240, size.height+5)];
    _note.text = _noteData.note;

    _avatarButton.frame = _nickname.frame;
    
    NSString * poke_count = [NSString stringWithFormat:@"%u", _noteData.poker_count];
    [_pokeButton setTitle:poke_count forState:UIControlStateNormal];
    [_pokeButton setFrame:CGRectMake(50., _note.frame.origin.y + _note.frame.size.height+10, 40, 25)];
    
    if(_noteData.poker_already)
    {
        _pokeButton.selected = YES;
        //_pokeButton.userInteractionEnabled = NO;
    }
    else
    {
        _pokeButton.selected = NO;
    }
    
    NSString * comment_count = [NSString stringWithFormat:@"%u", _noteData.comment_count];
    [_commentButton setTitle:comment_count forState:UIControlStateNormal];
    [_commentButton setFrame:CGRectMake(_pokeButton.frame.origin.x + _pokeButton.frame.size.width+15, _note.frame.origin.y+_note.frame.size.height, 40, 25)];
    _commentButton.userInteractionEnabled = YES;

    
    GKLog(@"%---------@", _noteData.created_time);
    [_time setTitle:[NSDate stringFromDate:_noteData.created_time WithFormatter:@"yyyy-MM-dd HH:mm"] forState:UIControlStateNormal];
    [_time setFrame:CGRectMake(190,self.frame.size.height-30, 120, 30)];
    
    [_seperatorLineImageView setFrame:CGRectMake(0, self.frame.size.height-1, kScreenWidth, 1)];
}


#pragma mark - button action
- (void)avatarButtonAction:(id)sender
{
    if (_delegate && [_delegate respondsToSelector:@selector(showUserWithUserID:)]) {
        [_delegate showUserWithUserID:_noteData.creator.user_id];
    }
}

- (void)pokeButtonAction:(id)sender
{
    if (_notedelegate && [_notedelegate respondsToSelector:@selector(tapPokeRoHootButtonWithNote:Poke:)])
    {
        if (![kUserDefault stringForKey:kSession])
        {
            [(GKAppDelegate *)[UIApplication sharedApplication].delegate showLoginView];
        }
        else {
            [_notedelegate tapPokeRoHootButtonWithNote:_noteData Poke:sender];
        }
    }
}

- (void)commentButtonAction:(id)sender
{
    if (_delegate && [_delegate respondsToSelector:@selector(showCommentWithNote:)]) {
        //[_delegate showCommentWithNote:_noteData];
    }
}


#pragma mark -
+ (float)height:(GKNote *)data
{
    UIFont *font = [UIFont fontWithName:@"Helvetica" size:14];
    
    CGSize size = [data.note sizeWithFont:font constrainedToSize:CGSizeMake(240, CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping];
    
    return size.height + 72; // 10即消息上下的空间，可自由调整
}
@end
