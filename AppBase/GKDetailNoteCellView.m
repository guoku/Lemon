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
@synthesize hootButton = _hootButton;
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
        [_avatar setFrame:CGRectMake(10, 13, 35, 35)];
        [self addSubview:_avatar];
        
        self.nickname = [[UILabel alloc]initWithFrame:CGRectMake(53, 13, 240, 15)];
        _nickname.textColor = UIColorFromRGB(0x666666);
        _nickname.font = [UIFont fontWithName:@"Helvetica-Bold" size:13];
        [_nickname setBackgroundColor:[UIColor clearColor]];
        [self addSubview:_nickname];
        
        y = _nickname.frame.origin.y + _nickname.frame.size.height;
        
        _ratingView = [[RatingView alloc]initWithFrame:CGRectZero];
        [_ratingView setImagesDeselected:@"star_s.png" partlySelected:@"star_s_half.png" fullSelected:@"star_s_full.png" andDelegate:nil];
        _ratingView.center = CGPointMake(_ratingView.center.x, 20);
        _ratingView.userInteractionEnabled = NO;
        [_ratingView displayRating:8/2];
        [self addSubview:_ratingView];
        
        self.note = [[GKNoteLabel alloc]initWithFrame:CGRectMake(53,y+2,240,400)];
        UIFont *font = [UIFont fontWithName:@"STHeitiSC-Light" size:13];
        _note.content.font = font;
        [_note setFontsize:13];
        _note.content.numberOfLines = 0;
        _note.content.leading = 2;
        _note.content.lineBreakMode = NSLineBreakByWordWrapping;
        [self addSubview:_note];
        
        self.avatarButton = [[UIButton alloc]initWithFrame:CGRectZero];
        [_avatarButton addTarget:self action:@selector(avatarButtonAction:) forControlEvents:UIControlEventTouchUpInside];        
        [self addSubview:_avatarButton];

        
        _pokeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_pokeButton addTarget:self action:@selector(pokeButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [_pokeButton setImage:[UIImage imageNamed:@"icon_zan.png"] forState:UIControlStateNormal];
        [_pokeButton setImage:[UIImage imageNamed:@"icon_zan_press.png"] forState:UIControlStateSelected];
        [_pokeButton setBackgroundImage:[UIImage imageNamed:@"detail_cell_button.png"]  forState:UIControlStateNormal];
        [_pokeButton setBackgroundImage:[UIImage imageNamed:@"detail_cell_button_press.png"]  forState:UIControlStateSelected];
        [_pokeButton.titleLabel setFont:[UIFont fontWithName:@"Helvetica" size:12.0f]];
        [_pokeButton setTitleColor:UIColorFromRGB(0x666666) forState:UIControlStateNormal];
        [_pokeButton.titleLabel setTextAlignment:NSTextAlignmentLeft];
        _pokeButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        [_pokeButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 8, 0, 0)];
        [self addSubview:_pokeButton];
        
        _hootButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_hootButton addTarget:self action:@selector(hootButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [_hootButton setImage:[UIImage imageNamed:@"icon_mai.png"] forState:UIControlStateNormal];
        [_hootButton setImage:[UIImage imageNamed:@"icon_mai_press.png"] forState:UIControlStateSelected];
        [_hootButton.titleLabel setFont:[UIFont fontWithName:@"Helvetica" size:12.0f]];
        [_hootButton setTitleColor:UIColorFromRGB(0x666666) forState:UIControlStateNormal];
        [_hootButton.titleLabel setTextAlignment:NSTextAlignmentLeft];
        [_hootButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
        [_hootButton setImageEdgeInsets:UIEdgeInsetsMake(2, 0, 0, 0)];
        [_hootButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 8, 0, 0)];
        //[self addSubview:_hootButton];
        //_hootButton.hidden = YES;
        
        
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
    _avatar.delegate = _delegate;
}
#pragma mark - layout view
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.backgroundView.frame = CGRectMake(0, 0, kScreenWidth, self.frame.size.height);
    
    self.avatar.creator = _noteData.creator;
    
    [self.nickname setText:[NSString stringWithFormat:@"%@ :",_noteData.creator.nickname]];
    
    UIFont *font = [UIFont fontWithName:@"Helvetica-Bold" size:13];
    CGSize size = [self.nickname.text sizeWithFont:font constrainedToSize:CGSizeMake(250, CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping];
    self.nickname.frame = CGRectMake(53, 13, size.width, size.height);
    
    _ratingView.frame = CGRectMake(53+size.width, 13,80 ,size.height);
    
    font = [UIFont fontWithName:@"STHeitiSC-Light" size:13];
    size = [_noteData.note sizeWithFont:font constrainedToSize:CGSizeMake(250, CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping];
    GKLog(@"%@",NSStringFromCGSize(size));
    [_note setFrame:CGRectMake(_note.frame.origin.x, _note.frame.origin.y, 250, size.height+10)];
    _note.note = _noteData;

    _avatarButton.frame = _nickname.frame;
    
    NSString * poke_count = [NSString stringWithFormat:@"%u", _noteData.poker_count];
    [_pokeButton setTitle:poke_count forState:UIControlStateNormal];
    [_pokeButton setFrame:CGRectMake(53., _note.frame.origin.y + _note.frame.size.height + 5, 40, 25)];
    
    NSString * _hoot_count = [NSString stringWithFormat:@"%u", _noteData.hooter_count];
    [_hootButton setTitle:_hoot_count forState:UIControlStateNormal];
    _hootButton.frame = CGRectMake(_pokeButton.frame.origin.x + _pokeButton.frame.size.width,  _note.frame.origin.y + _note.frame.size.height+5, 40., 25);

//    GKLog(@"%@", _noteData.note_poke);
    switch (_noteData.note_poke.poked_or_hooted) {
        case kPoker:
        {
            _pokeButton.selected = YES;
            _pokeButton.userInteractionEnabled = NO;
            _hootButton.selected = NO;
            _hootButton.userInteractionEnabled = YES;
        }
            break;
        case kHooter:
        {
            _pokeButton.selected = NO;
            _pokeButton.userInteractionEnabled = YES;
            _hootButton.selected = YES;
            _hootButton.userInteractionEnabled = NO;
        }
            break;
        default:
        {
            _pokeButton.selected = NO;
            _hootButton.selected = NO;
            _pokeButton.userInteractionEnabled = YES;
            _hootButton.userInteractionEnabled = YES;
        }
            break;
    }
    
    NSString * comment_count = [NSString stringWithFormat:@"%u", _noteData.comment_count];
    [_commentButton setTitle:comment_count forState:UIControlStateNormal];
    [_commentButton setFrame:CGRectMake(_pokeButton.frame.origin.x + _pokeButton.frame.size.width+15, _note.frame.origin.y+_note.frame.size.height, 40, 25)];
    _commentButton.userInteractionEnabled = YES;

    
    GKLog(@"%---------@", _noteData.created_time);
    [_time setTitle:[NSDate stringFromDate:_noteData.created_time WithFormatter:@"yyyy-MM-dd HH:yy"] forState:UIControlStateNormal];
    [_time setFrame:CGRectMake(190, _note.frame.origin.y+_note.frame.size.height+12, 120, 30)];
    
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
    if (_notedelegate && [_notedelegate respondsToSelector:@selector(tapPokeRoHootButtonWithNote:Poke:Hoot:Stats:)])
    {
        if (![kUserDefault stringForKey:kSession])
        {
            [(GKAppDelegate *)[UIApplication sharedApplication].delegate showLoginView];
        }
        else {
        [_notedelegate tapPokeRoHootButtonWithNote:_noteData Poke:sender Hoot:_hootButton Stats:kPoker];
        }
    }
}

- (void)hootButtonAction:(id)sender
{
    
//    NSLog(@"i2");
    if (_notedelegate && [_notedelegate respondsToSelector:@selector(tapPokeRoHootButtonWithNote:Poke:Hoot:Stats:)])
    {
        if (![kUserDefault stringForKey:kSession])
        {
            [(GKAppDelegate *)[UIApplication sharedApplication].delegate showLoginView];
        }
        else {
        [_notedelegate tapPokeRoHootButtonWithNote:_noteData Poke:_pokeButton Hoot:sender Stats:kHooter];
        }
    }
}

- (void)commentButtonAction:(id)sender
{
    if (_delegate && [_delegate respondsToSelector:@selector(showCommentWithNote:)]) {
 //       [_delegate showCommentWithNote:_noteData];
    }
}


#pragma mark -
+ (float)height:(GKNote *)data
{
    UIFont *font = [UIFont fontWithName:@"STHeitiSC-Light" size:13];
    
    CGSize size = [data.note sizeWithFont:font constrainedToSize:CGSizeMake(250, CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping];
    
    return size.height + 75; // 10即消息上下的空间，可自由调整
}
@end
