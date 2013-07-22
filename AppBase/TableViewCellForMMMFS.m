//
//  TableViewCellForMMMFS.m
//  MMM
//
//  Created by huiter on 13-7-20.
//  Copyright (c) 2013年 guoku. All rights reserved.
//

#import "TableViewCellForMMMFS.h"

@implementation TableViewCellForMMMFS
@synthesize data = _data;
@synthesize delegate = _delegate;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)setData:(MMMKWDFS *)data
{
    _data = data;
    [self setNeedsLayout];
}

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
    self.backgroundColor = UIColorFromRGB(0xf9f9f9);
    UIImageView * bg = [[UIImageView alloc]initWithFrame:CGRectMake(8, 8, self.frame.size.width-16, self.frame.size.height-16)];
    bg.image = [[UIImage imageNamed:@"tables_single.png"]stretchableImageWithLeftCapWidth:10 topCapHeight:10];
    [self addSubview:bg];
    
    GKItemButton *_entityImageView = [[GKItemButton alloc] initWithFrame:CGRectZero];
    _entityImageView.entity = _data;
    [_entityImageView setFrame:CGRectMake(20, 20, 80, 80)];
    [self addSubview:_entityImageView];
    _entityImageView.delegate = self.delegate;
    
    UILabel * _brand = [[UILabel alloc]initWithFrame:CGRectZero];
    _brand.backgroundColor = [UIColor clearColor];
    
    _brand.font = [UIFont fontWithName:@"Helvetica" size:12.0f];
    _brand.textAlignment = NSTextAlignmentLeft;
    _brand.textColor = UIColorFromRGB(0x666666);
    [self addSubview:_brand];
    
    UILabel *_title = [[UILabel alloc]initWithFrame:CGRectZero];
    _title.backgroundColor = [UIColor clearColor];
    
    _title.font = [UIFont fontWithName:@"Helvetica" size:12.0f];
    _title.textAlignment = NSTextAlignmentLeft;
    _title.textColor = UIColorFromRGB(0x666666);
    [self addSubview:_title];
    
    RatingView *_ratingView = [[RatingView alloc]initWithFrame:CGRectZero];
    [_ratingView setImagesDeselected:@"star_s.png" partlySelected:@"star_s_half.png" fullSelected:@"star_s_full.png" andDelegate:nil];
    _ratingView.userInteractionEnabled = NO;
    [self addSubview:_ratingView];
    
    UILabel *_price = [[UILabel alloc]initWithFrame:CGRectZero];
    _price.backgroundColor = [UIColor clearColor];
    
    _price.font = [UIFont fontWithName:@"Helvetica" size:12.0f];
    _price.textAlignment = NSTextAlignmentLeft;
    _price.textColor = UIColorFromRGB(0x666666);
    [self addSubview:_price];
    
    CGFloat y = 20;
    if( !([_data.brand isEqualToString:@""])) {
        _brand.frame = CGRectMake(105, y, 145, 15);
        y = _brand.frame.origin.y+_brand.frame.size.height;
    }
    _title.frame = CGRectMake(105, y, 145, 15);
    y = _title.frame.origin.y+_title.frame.size.height;
    
    _ratingView.frame = CGRectMake(105, y, 145, 20);
    [_ratingView displayRating:_data.avg_score/2];
    y = _ratingView.frame.origin.y+_ratingView.frame.size.height;
    
    _price.frame = CGRectMake(105, y, 145, 20);
    
    _brand.text = _data.brand;
    _title.text = _data.title;
    if(_data.price != 0)
    {
        NSString * priceTitle = [NSString stringWithFormat:@"￥%.2f", _data.price];
        _price.text = priceTitle ;
    }
    UILabel *_count = [[UILabel alloc]initWithFrame:CGRectMake(20,110, 140, 30)];
    _count.backgroundColor = [UIColor clearColor];
    _count.font = [UIFont fontWithName:@"Helvetica" size:12.0f];
    _count.textAlignment = NSTextAlignmentLeft;
    _count.textColor = UIColorFromRGB(0x666666);
    [self addSubview:_count];
    if([_data.likes_user_list count])
    {
        _count.text = [NSString stringWithFormat:@"%u位好友收藏",[_data.likes_user_list count]];
        [self showLikeUser];
    }
    else
    {
        [GKUserBase getUserBaseByArray:_data.likes_list  Block:^(NSArray *list, NSError *error) {
            if(!error)
            {   _data.likes_user_list = [NSMutableArray arrayWithArray:list];
                [self showLikeUser];
            }
        }];
    }
    CGFloat note_offset = 150;
    for (GKNote * note in _data.notes_list) {
        
        UIView * H = [[UIView alloc]initWithFrame:CGRectMake(0, note_offset, self.frame.size.width, 1)];
        H.backgroundColor = UIColorFromRGB(0xf1f1f1);
        [self addSubview:H];
        
        GKUserButton * _avatar = [[GKUserButton alloc]initWithFrame:CGRectZero useBg:NO cornerRadius:2];
        [_avatar setFrame:CGRectMake(20, note_offset+13, 35, 35)];
        _avatar.userBase = note.creator;
        _avatar.delegate = _delegate;
        [self addSubview:_avatar];
        
        UILabel *_nickname = [[UILabel alloc]initWithFrame:CGRectMake(63, note_offset+13, 240, 15)];
        _nickname.textColor = UIColorFromRGB(0x666666);
        _nickname.font = [UIFont fontWithName:@"Helvetica-Bold" size:13];
        [_nickname setBackgroundColor:[UIColor clearColor]];
        [_nickname setText:note.creator.nickname];
        [self addSubview:_nickname];
        
        y = _nickname.frame.origin.y + _nickname.frame.size.height;
        
        RatingView *_ratingView = [[RatingView alloc]initWithFrame:CGRectZero];
        [_ratingView setImagesDeselected:@"star_s.png" partlySelected:@"star_s_half.png" fullSelected:@"star_s_full.png" andDelegate:nil];
        _ratingView.userInteractionEnabled = NO;
        [self addSubview:_ratingView];
        
        UILabel * _note = [[UILabel alloc]initWithFrame:CGRectMake(63,y+2,240,400)];
        _note.font = [UIFont fontWithName:@"STHeitiSC-Light" size:13];
        _note.numberOfLines = 0;
        _note.textAlignment = NSTextAlignmentLeft;
        _note.textColor = UIColorFromRGB(0x666666);
        _note.backgroundColor = [UIColor clearColor];
        _note.lineBreakMode = NSLineBreakByWordWrapping;
        [self addSubview:_note];
        
        UIFont *font = [UIFont fontWithName:@"Helvetica-Bold" size:13];
        CGSize size = [_nickname.text sizeWithFont:font constrainedToSize:CGSizeMake(250, CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping];
        _nickname.frame = CGRectMake(63, note_offset+13, size.width, size.height);
        
        _ratingView.frame = CGRectMake(63+size.width, note_offset+15,80 ,size.height);
        [_ratingView displayRating:note.score/2];
        
        font = [UIFont fontWithName:@"STHeitiSC-Light" size:13];
        size = [note.note sizeWithFont:font constrainedToSize:CGSizeMake(240, CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping];
        GKLog(@"%@",NSStringFromCGSize(size));
        [_note setFrame:CGRectMake(_note.frame.origin.x, _note.frame.origin.y, 240, size.height+5)];
        _note.text = note.note;
        
        note_offset = note_offset+size.height;


    }
}
-(void)showLikeUser
{
    int i = 0;
    for (GKUserBase * user in _data.likes_user_list) {
        GKUserButton *avatar = [[GKUserButton alloc]initWithFrame:CGRectMake(100+i*34,110, 30, 30) useBg:NO cornerRadius:0];
        avatar.userBase = user;
        avatar.delegate = _delegate;
        [self addSubview:avatar];
        i++;
        if(i>=6)
        {
            break;
        }
    }
    return;
}
+ (float)height:(MMMKWDFS *)data;
{
    CGFloat y = 200;
    for (GKNote * note in data.notes_list) {
        
        UIFont *font = [UIFont fontWithName:@"STHeitiSC-Light" size:13];
        CGSize size = [note.note sizeWithFont:font constrainedToSize:CGSizeMake(240, CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping];
        y = y+size.height;
    }
    return y;
}
@end
