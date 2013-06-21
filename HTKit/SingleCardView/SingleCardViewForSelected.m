//
//  SingleCardViewForSelected.m
//  Grape
//
//  Created by huiter on 13-3-25.
//  Copyright (c) 2013年 guoku. All rights reserved.
//

#import "SingleCardViewForSelected.h"
#import "GKSelection.h"
#import "NSDate+GKHelper.h"
@implementation SingleCardViewForSelected
{
@private
    UIImageView *_seperatorLineImageView;
    __strong GKNote * _note;
    CGFloat x;
    CGFloat y;
    UIButton *_avatarButton;
}


@synthesize img = _img;
@synthesize avatar = _avatar;
@synthesize likeButton = _likeButton;
@synthesize description = _description;
@synthesize authoruser = _authoruser;
@synthesize time = _time;
@synthesize notetime = _notetime;
@synthesize noteButton = _noteButton;
@synthesize delegate = _delegate;



- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        
        self.time = [[UIButton alloc]initWithFrame:CGRectMake(0,10,kScreenWidth-10,9)];
        [_time setImage:[UIImage imageNamed:@"icon_clock.png"] forState:UIControlStateNormal];
        [_time.titleLabel setFont:[UIFont fontWithName:@"Helvetica" size:9.0f]];
        [_time setTitleColor:kColor666666 forState:UIControlStateNormal];
        [_time.titleLabel setTextAlignment:UITextAlignmentLeft];
        _time.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        _time.userInteractionEnabled = NO;
        [_time setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 3)];
        _time.hidden = YES;
        [self addSubview:_time];
        
        self.img = [[GKItemButton alloc] init];
        [_img setType:kItemButtonWithNumProgress];
        [_img setFrame:CGRectMake(5,14,310,310)];
        [self addSubview:_img];
        
        y = _img.frame.origin.y + _img.frame.size.height;
        
        self.avatar = [[GKUserButton alloc] initWithFrame:CGRectMake(20,y+8,30,30)];
        [self addSubview:_avatar];
        
        _authoruser = [[UILabel alloc] initWithFrame:CGRectZero];
        [_authoruser setFrame:CGRectMake(_avatar.frame.origin.x+_avatar.frame.size.width+5,y+5, kScreenWidth, 14)];
        [_authoruser setAdjustsFontSizeToFitWidth:NO];
        [_authoruser setNumberOfLines:1];
        [_authoruser setBackgroundColor:[UIColor clearColor]];
        [_authoruser setLineBreakMode:UILineBreakModeTailTruncation];
        [_authoruser setTextAlignment:UITextAlignmentLeft];
        [_authoruser setFont:[UIFont fontWithName:@"Helvetica-Bold" size:14.0f]];
        [_authoruser setTextColor:kColor666666];
        [self addSubview:_authoruser];
        
        _avatarButton = [[UIButton alloc]initWithFrame:CGRectZero];
        [_avatarButton addTarget:self action:@selector(avatarButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_avatarButton];
        

        
        self.notetime = [[UIButton alloc]initWithFrame:CGRectZero];
        [_notetime setImage:[UIImage imageNamed:@"icon_clock.png"] forState:UIControlStateNormal];
        [_notetime setFrame:CGRectMake(_avatar.frame.origin.x+_avatar.frame.size.width+5, y+26, kScreenWidth-_avatar.frame.origin.x-_avatar.frame.origin.x-_avatar.frame.size.width-9,12)];
        [_notetime.titleLabel setFont:[UIFont fontWithName:@"Helvetica" size:9.0f]];
        [_notetime setTitleEdgeInsets:UIEdgeInsetsMake(0, 2, 0, 0)];
        [_notetime setTitleColor:kColor666666 forState:UIControlStateNormal];
        [_notetime.titleLabel setTextAlignment:UITextAlignmentLeft];
        _notetime.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        _notetime.userInteractionEnabled = NO;
        [self addSubview:_notetime];
        
        y = _avatar.frame.origin.y + _avatar.frame.size.height;
        
        _description = [[GKNoteLabel alloc] initWithFrame:CGRectZero];
        [_description setFrame:CGRectMake(_avatar.frame.origin.x,y+5,kScreenWidth - 2*_avatar.frame.origin.x,56)];
        [_description.content setLeading:2];
        [self addSubview:_description];
        
        y = _description.frame.origin.y + _description.frame.size.height;
        
        self.likeButton = [[GKLikeButton alloc]init ];
        _likeButton.frame = CGRectMake(_avatar.frame.origin.x, y, 160 - _avatar.frame.origin.x, 30);
        [self addSubview:_likeButton];
        
        self.noteButton = [[UIButton alloc]initWithFrame:CGRectMake(160, y, 160-_avatar.frame.origin.x, 30)];
        [_noteButton.titleLabel setFont:[UIFont fontWithName:@"Helvetica" size:12.0f]];
        [_noteButton setTitleColor:kColor666666 forState:UIControlStateNormal];
        [_noteButton setImage:[UIImage imageNamed:@"icon_note.png"] forState:UIControlStateNormal];
        [_noteButton.titleLabel setTextAlignment:UITextAlignmentLeft];
        _noteButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        [_noteButton setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 5)];
        [_noteButton addTarget:self action:@selector(itemCardWithDataButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_noteButton];
        
        
        y = self.noteButton.frame.origin.y + self.noteButton.frame.size.height;
        
        y = _likeButton.frame.origin.y + _likeButton.frame.size.height;
        
        _seperatorLineImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
         [_seperatorLineImageView setImage:[UIImage imageNamed:@"splitline.png"]];
         [self addSubview:_seperatorLineImageView];
    }
    return self;
}
- (void)setDelegate:(id<GKDelegate>)delegate
{
    _delegate = delegate;
    _img.delegate = _delegate;
    _avatar.delegate = _delegate;
    _description.gkdelegate = _delegate;

}
- (void)setSelection:(GKSelection *)selection
{
    if ([selection isKindOfClass:[GKSelection class]]) {
        _selection = selection;
        for (GKNote *note in _selection.notes_list) {
            if(note.added_to_selection == YES)
            {
                _note = note;
            }
        }
        if((_note ==nil)&&([_selection.notes_list count]>0))
        {
            _note =  _selection.notes_list[0];
        }
    }
    [self setNeedsLayout];
}
#pragma mark -  layout subviews
- (void)layoutSubviews
{
    [_time setTitle:[NSString stringWithFormat:@"%@收入精选",[_selection.created_time stringByMessageFormatLongFormat:YES]]forState:UIControlStateNormal];

    _img.entity = _selection;
    _avatar.creator = _note.creator;
    
    [_authoruser setText:_note.creator.nickname];
    
    UIFont *font = [UIFont fontWithName:@"Helvetica-Bold" size:15];
    CGSize labelsize = [_authoruser.text sizeWithFont:font constrainedToSize:CGSizeMake(CGFLOAT_MAX, 18) lineBreakMode:NSLineBreakByWordWrapping];
    [_authoruser setFrame:CGRectMake(_authoruser.frame.origin.x, _authoruser.frame.origin.y, labelsize.width, labelsize.height)];
    //[_notetime setTitle:[NSString stringWithFormat:@"点评于%@",[NSDate stringFromDate:_note.created_time WithFormatter:@"yyyy年MM月dd日"]] forState:UIControlStateNormal];
    [_notetime setTitle:[NSString stringWithFormat:@"%@被收录精选",[_selection.created_time stringByMessageFormatLongFormat:YES]]forState:UIControlStateNormal];
    
    _avatarButton.frame = _authoruser.frame;
    
    _description.note = _note;
    
    _likeButton.frame = CGRectMake(_avatar.frame.origin.x, _description.frame.origin.y+_description.frame.size.height, 160 - _avatar.frame.origin.x, 30);
    
    _noteButton.frame = CGRectMake(_noteButton.frame.origin.x, _likeButton.frame.origin.y,_noteButton.frame.size.width, _noteButton.frame.size.height);

    
    _likeButton.data = _selection;
    
    if(([_selection.notes_list count]-1 )!= 0)
    {
        NSString * note_count = [NSString stringWithFormat:@"还有%u条点评", [_selection.notes_list count]-1];
        [_noteButton setTitle:note_count forState:UIControlStateNormal];
        _noteButton.hidden = NO;
    }
    else
    {
        _noteButton.hidden = YES;
    }
    
    [_seperatorLineImageView setFrame:CGRectMake(0, self.frame.size.height-2, kScreenWidth, 2)];

}
- (void)itemCardWithDataButtonAction:(id)sender
{
    
    if (_delegate && [_delegate respondsToSelector:@selector(showDetailWithData:)]) {
        [_delegate showDetailWithData:_selection];
    }
}
- (void)avatarButtonAction:(id)sender
{
    if (_delegate && [_delegate respondsToSelector:@selector(showUserWithUserID:)]) {
        [_delegate showUserWithUserID:_note.creator.user_id];
    }
}

@end
