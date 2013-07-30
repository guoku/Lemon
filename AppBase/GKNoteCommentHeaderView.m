//
//  GKNoteCommentHeaderView.m
//  Grape
//
//  Created by huiter on 13-3-30.
//  Copyright (c) 2013年 guoku. All rights reserved.
//

#import "GKNoteCommentHeaderView.h"
#import "NSDate+GKHelper.h"
#import "GKAppDelegate.h"
@implementation GKNoteCommentHeaderView
{
@private
    CGFloat y;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _poke_user_list = [[NSMutableArray alloc]initWithCapacity:0];
        self.backgroundColor = UIColorFromRGB(0xffffff);
        self.entityButton = [[UIButton alloc]initWithFrame:CGRectMake(0,0,kScreenWidth , 85)];
        [_entityButton setBackgroundColor:UIColorFromRGB(0xf1f1f1)];
        
        UIImageView *arrow = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"arrow.png"]];
        arrow.center = CGPointMake(_entityButton.frame.size.width-15, _entityButton.frame.size.height/2);
        [_entityButton addSubview:arrow];
        
        //商品图片
        self.entityImageView = [[GKItemButton alloc] initWithFrame:CGRectZero];
        [_entityImageView setFrame:CGRectMake(10,10,60,60)];
        _entityImageView.userInteractionEnabled = NO;
        [_entityButton addSubview:_entityImageView];
        
        self.brand = [[UILabel alloc]initWithFrame:CGRectZero];
        _brand.backgroundColor = [UIColor clearColor];
        _brand.font = [UIFont fontWithName:@"Helvetica" size:15.0f];
        _brand.textAlignment = NSTextAlignmentLeft;
        _brand.textColor =UIColorFromRGB(0x555555);
        [_entityButton addSubview:_brand];
        
        self.title = [[UILabel alloc]initWithFrame:CGRectZero];
        _title.backgroundColor = [UIColor clearColor];
        
        _title.font = [UIFont fontWithName:@"Helvetica" size:15.0f];
        _title.textAlignment = NSTextAlignmentLeft;
        _title.textColor =UIColorFromRGB(0x555555);
        [_entityButton addSubview:_title];
        
        _ratingView = [[RatingView alloc]initWithFrame:CGRectZero];
        [_ratingView setImagesDeselected:@"star_s.png" partlySelected:@"star_s_half.png" fullSelected:@"star_s_full.png" andDelegate:nil];
        _ratingView.center = CGPointMake(_ratingView.center.x, 22);
        _ratingView.userInteractionEnabled = NO;
        [_entityButton addSubview:_ratingView];
        
        _score = [[UILabel alloc]initWithFrame:CGRectZero];
        _score.textAlignment = NSTextAlignmentLeft;
        _score.backgroundColor = [UIColor clearColor];
        _score.textColor =UIColorFromRGB(0x999999);
        _score.font = [UIFont fontWithName:@"Helvetica" size:13.0f];
        [_entityButton addSubview:_score];
        
        [_entityButton addTarget:self action:@selector(goEntity) forControlEvents:UIControlEventTouchUpInside];

        [self addSubview:_entityButton];
        
        
        UIView * noteView = [[UIView alloc]initWithFrame:CGRectMake(0, 80, kScreenWidth, self.frame.size.height - 125)];
        noteView.backgroundColor = UIColorFromRGB(0xf9f9f9);
        self.avatar = [[GKUserButton alloc]initWithFrame:CGRectZero useBg:NO cornerRadius:2];
        [_avatar setFrame:CGRectMake(10, 13, 40, 40)];
        [noteView addSubview:_avatar];
        
        self.nickname = [[UILabel alloc]initWithFrame:CGRectMake(55, 23, 120, 20)];
        _nickname.textColor = UIColorFromRGB(0x666666);
        _nickname.font = [UIFont fontWithName:@"Helvetica-Bold" size:14];
        [_nickname setBackgroundColor:[UIColor clearColor]];
        [noteView addSubview:_nickname];
        
        self.time = [[UIButton alloc]initWithFrame:CGRectMake(190, noteView.frame.size.height-20,125, 20)];
        [_time setImage:[UIImage imageNamed:@"icon_clock"] forState:UIControlStateNormal];
        [_time.titleLabel setFont:[UIFont fontWithName:@"Helvetica" size:10.0f]];
        [_time setTitleColor:UIColorFromRGB(0x999999) forState:UIControlStateNormal];
        [_time.titleLabel setTextAlignment:NSTextAlignmentLeft];
        [_time setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 2)];
        _time.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        _time.userInteractionEnabled = NO;
        [noteView addSubview:_time];
        
        self.noteRatingView = [[RatingView alloc]initWithFrame:CGRectZero];
        [_noteRatingView setImagesDeselected:@"star_s.png" partlySelected:@"star_s_half.png" fullSelected:@"star_s_full.png" andDelegate:nil];
        _noteRatingView.center = CGPointMake(_noteRatingView.center.x, 34);
        _noteRatingView.userInteractionEnabled = NO;
        [noteView addSubview:_noteRatingView];
        
        self.note = [[UILabel alloc]initWithFrame:CGRectMake(12,_avatar.frame.origin.y + _avatar.frame.size.height+2, 300, 400)];
        _note.backgroundColor = [UIColor clearColor];
        _note.font = [UIFont fontWithName:@"Helvetica" size:14];
        _note.textColor = UIColorFromRGB(0x666666);
        _note.numberOfLines = 0;
        [noteView addSubview:_note];
        
        self.avatarButton = [[UIButton alloc]initWithFrame:_nickname.frame];
        [_avatarButton addTarget:self action:@selector(avatarButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [noteView addSubview:_avatarButton];
        
        noteView.backgroundColor = UIColorFromRGB(0xf9f9f9);
        [self addSubview:noteView];
        
        UIImageView *H = [[UIImageView alloc] initWithFrame:CGRectMake(0, self.frame.size.height-46, kScreenWidth, 1)];
        H.backgroundColor = [UIColor colorWithRed:238.0f / 255.0f green:238.0f / 255.0f blue:238.0 / 255.0f alpha:1.0f]
        ;
        [self addSubview:H];
        
        _seperatorLineImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, self.frame.size.height-1, kScreenWidth, 1)];
        _seperatorLineImageView.backgroundColor = [UIColor colorWithRed:238.0f / 255.0f green:238.0f / 255.0f blue:238.0 / 255.0f alpha:1.0f]
        ;
        [self addSubview:_seperatorLineImageView];
        
        UIImageView * arrow1 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"review_arrow.png"]];
        arrow1.frame = CGRectMake(24, self.frame.size.height - 52, 12, 7);
        [self addSubview:arrow1];
        
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
        

        
    }
    return self;
}

- (void)setNoteData:(GKNote *)noteData entityData:(GKEntity *)entity
{
    _noteData = noteData;
    _entity = entity;

    if([_noteData.poke_id_list count]!=[_poke_user_list count])
    {
        NSMutableArray *array = [[NSMutableArray alloc]initWithCapacity:0];
        int i =0;
        for(NSString *user_id in _noteData.poke_id_list)
        {
            [array addObject:user_id];
            i++;
            if(i>10)
            {
                break;
            }
        }
        for (UIView * view in self.subviews) {
            if (view.tag ==1000) {
                [view removeFromSuperview];
            }
        }
            [GKUserBase getUserBaseByArray:array  Block:^(NSArray *list, NSError *error) {
                if(!error)
                {
                    int i = 0;
                    _poke_user_list = [NSMutableArray arrayWithArray:list];
                    for (GKUserBase * user in _poke_user_list) {
                        GKUserButton *avatar = [[GKUserButton alloc]initWithFrame:CGRectMake(9+i*34,self.frame.size.height-37, 30, 30) useBg:NO cornerRadius:0];
                        avatar.userBase = user;
                        avatar.tag = 1000;
                        avatar.delegate = _delegate;
                        [self addSubview:avatar];
                        i++;
                        if(i>=9)
                        {
                            break;
                        }
                    }
                }
            }];
    }
    else
    {
        for (UIView * view in self.subviews) {
            if (view.tag ==1000) {
                [view removeFromSuperview];
            }
        }
        int i = 0;
        for (GKUserBase * user in _poke_user_list) {
            GKUserButton *avatar = [[GKUserButton alloc]initWithFrame:CGRectMake(9+i*34,self.frame.size.height-37, 30, 30) useBg:NO cornerRadius:0];
            avatar.userBase = user;
            avatar.tag = 1000;
            avatar.delegate = _delegate;
            [self addSubview:avatar];
            i++;
            if(i>=9)
            {
                break;
            }
        }

    }
    [self setNeedsLayout];
}
- (void)setNoteData:(GKNote *)noteData
{
    _noteData = noteData;
    
    if([_noteData.poke_id_list count]!=[_poke_user_list count])
    {
        NSMutableArray *array = [[NSMutableArray alloc]initWithCapacity:0];
        int i =0;
        for(NSString *user_id in _noteData.poke_id_list)
        {
            [array addObject:user_id];
            i++;
            if(i>10)
            {
                break;
            }
        }
        for (UIView * view in self.subviews) {
            if (view.tag ==1000) {
                [view removeFromSuperview];
            }
        }
        [GKUserBase getUserBaseByArray:array  Block:^(NSArray *list, NSError *error) {
            if(!error)
            {
                int i = 0;
                _poke_user_list = [NSMutableArray arrayWithArray:list];
                for (GKUserBase * user in _poke_user_list) {
                    GKUserButton *avatar = [[GKUserButton alloc]initWithFrame:CGRectMake(9+i*34,self.frame.size.height-37, 30, 30) useBg:NO cornerRadius:0];
                    avatar.userBase = user;
                    avatar.tag = 1000;
                    avatar.delegate = _delegate;
                    [self addSubview:avatar];
                    i++;
                    if(i>=9)
                    {
                        break;
                    }
                }
            }
        }];
    }
    else
    {
        for (UIView * view in self.subviews) {
            if (view.tag ==1000) {
                [view removeFromSuperview];
            }
        }
        int i = 0;
        for (GKUserBase * user in _poke_user_list) {
            GKUserButton *avatar = [[GKUserButton alloc]initWithFrame:CGRectMake(10+i*34,self.frame.size.height-37, 30, 30) useBg:NO cornerRadius:0];
            avatar.userBase = user;
            avatar.tag = 1000;
            avatar.delegate = _delegate;
            [self addSubview:avatar];
            i++;
            if(i>=9)
            {
                break;
            }
        }
        
    }
    [self setNeedsLayout];
}
- (void)setDelegate:(id<GKDelegate>)delegate
{
    _delegate = delegate;
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
    
    y =10;
    _entityImageView.entity = _entity;
    _brand.text = _entity.brand;
    _title.text = _entity.title;
    if( !([_entity.brand isEqualToString:@""])) {
        _brand.frame = CGRectMake(80, y,kScreenWidth-90, 20);
        y = _brand.frame.origin.y+_brand.frame.size.height;
    }
    _title.frame = CGRectMake(80, y, kScreenWidth-90, 20);
    y = _title.frame.origin.y+_title.frame.size.height+2;
    
    _ratingView.frame = CGRectMake(80, y, 60, 20);
    [_ratingView displayRating:_entity.avg_score/2];
    _score.frame = CGRectMake(_ratingView.frame.origin.x+_ratingView.frame.size.width+1 , _ratingView.frame.origin.y-4, 40, 20);
    _score.text = [NSString stringWithFormat:@"%0.1f",_entity.avg_score];


    
    self.avatar.userBase = _noteData.creator;
    
    [self.nickname setText:[NSString stringWithFormat:@"%@ :",_noteData.creator.nickname]];
   
    CGSize size = [_nickname.text sizeWithFont:_nickname.font constrainedToSize:CGSizeMake(CGFLOAT_MAX,20) lineBreakMode:NSLineBreakByWordWrapping];
    _nickname.frame = CGRectMake(_nickname.frame.origin.x, _nickname.frame.origin.y, size.width, 20);
    _noteRatingView.frame = CGRectMake(_nickname.frame.origin.x + _nickname.frame.size.width+2, _nickname.frame.origin.y+5, 60, 20);
    [_noteRatingView displayRating:_noteData.score/2];
    
    
    
    [_time setTitle:[NSDate stringFromDate:_noteData.created_time WithFormatter:@"yyyy-MM-dd HH:mm"] forState:UIControlStateNormal];
    
    size = [_noteData.note sizeWithFont:_note.font constrainedToSize:CGSizeMake(300, CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping];
    [_note setFrame:CGRectMake(_note.frame.origin.x, _note.frame.origin.y, 300, size.height)];
    _note.text = _noteData.note;
    
    NSString * poke_count = [NSString stringWithFormat:@"%u", _noteData.poker_count];
    [_pokeButton setTitle:poke_count forState:UIControlStateNormal];
    [_pokeButton setFrame:CGRectMake(11, self.frame.size.height - 80, 40, 25)];
    if(_noteData.poker_already)
    {
        _pokeButton.selected = YES;
        //_pokeButton.userInteractionEnabled = NO;
    }
    else
    {
        _pokeButton.selected = NO;
    }
}
+ (float)height:(GKNote *)data
{
    UIFont *font = [UIFont fontWithName:@"Helvetica" size:14];
    
    CGSize size = [data.note sizeWithFont:font constrainedToSize:CGSizeMake(300, CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping];
    
    return (size.height+220); // 10即消息上下的空间，可自由调整
}
- (void)goEntity
{
    [self.delegate showDetailWithData:_entity];
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
@end
