//
//  TableViewCellForMMMFS.m
//  MMM
//
//  Created by huiter on 13-7-20.
//  Copyright (c) 2013年 guoku. All rights reserved.
//

#import "TableViewCellForMMMFS.h"

@implementation TableViewCellForMMMFS
{
@private
    NSMutableArray * user_list;
    BOOL flag;
}
@synthesize data = _data;
@synthesize delegate = _delegate;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        user_list = [[NSMutableArray alloc]initWithCapacity:0];
        flag = YES;
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
    
    UIImageView * bg = [[UIImageView alloc]initWithFrame:CGRectMake(8, 8, self.frame.size.width-16, self.frame.size.height-16)];
    bg.image = [[UIImage imageNamed:@"tables_single.png"]stretchableImageWithLeftCapWidth:10 topCapHeight:10];
    [self addSubview:bg];
    CGFloat y = 15;
    
    _img = [[GKItemButton alloc] initWithFrame:CGRectMake(5, y, 145, 145)];
    [_img setType:kItemButtonWithNumProgress];
    [self addSubview:_img];
    
    
    y = _img.frame.origin.y+_img.frame.size.height;
    
    self.rating = [[RatingView alloc]initWithFrame:CGRectZero];
    _rating.frame = CGRectMake(0, y, 70, 10);
    [_rating setImagesDeselected:@"star_s.png" partlySelected:@"star_s_half.png" fullSelected:@"star_s_full.png" andDelegate:nil];
    _rating.userInteractionEnabled = NO;
    _rating.center = CGPointMake(self.frame.size.width/2, _rating.center.y);
    [self addSubview:_rating];
    
    self.brand = [[UILabel alloc]initWithFrame:CGRectZero];
    _brand.backgroundColor = [UIColor clearColor];
    
    _brand.font = [UIFont fontWithName:@"Helvetica" size:12.0f];
    _brand.textAlignment = NSTextAlignmentCenter;
    _brand.textColor = UIColorFromRGB(0x666666);
    [self addSubview:_brand];
    
    self.title = [[UILabel alloc]initWithFrame:CGRectZero];
    _title.backgroundColor = [UIColor clearColor];
    
    _title.font = [UIFont fontWithName:@"Helvetica" size:12.0f];
    _title.textAlignment = NSTextAlignmentCenter;
    _title.textColor = UIColorFromRGB(0x666666);
    [self addSubview:_title];
    
    self.price = [[UILabel alloc]initWithFrame:CGRectZero];
    _price.backgroundColor = [UIColor clearColor];
    
    _price.font = [UIFont fontWithName:@"Helvetica" size:12.0f];
    _price.textAlignment = NSTextAlignmentCenter;
    _price.textColor = UIColorFromRGB(0x666666);
    [self addSubview:_price];
    
    y = _rating.frame.origin.y+_rating.frame.size.height;
    if( !([_data.brand isEqualToString:@""])) {
        _brand.frame = CGRectMake(5, y, 145, 20);
        y = _brand.frame.origin.y+_brand.frame.size.height;
    }
    _title.frame = CGRectMake(5, y, 145, 20);
    y = _title.frame.origin.y+_title.frame.size.height;
    _price.frame = CGRectMake(5, y, 145, 20);
    
    _img.entity = _data;
    _likeButton.data = _data;
    [_rating displayRating:_data.avg_score/2];
    _brand.text = _data.brand;
    _title.text = _data.title;
    NSString * priceTitle = [NSString stringWithFormat:@"￥%.2f", _data.price];
    _price.text = priceTitle ;
    
    if((flag)&&([_data.likes_list count]))
    {
        [GKUserBase getUserBaseByArray:_data.likes_list  Block:^(NSArray *list, NSError *error) {
            flag = NO;
            if(!error)
            {
                [self showLikeUser];
            }
        }];
    }
    else
    {
        [self showLikeUser];
    }
    for (GKNote * note in _data.notes_list) {
        GKUserButton * _avatar = [[GKUserButton alloc]initWithFrame:CGRectZero useBg:NO cornerRadius:2];
        [_avatar setFrame:CGRectMake(10, 13, 35, 35)];
        _avatar.userBase = note.creator;
        [self addSubview:_avatar];
        
        UILabel *_nickname = [[UILabel alloc]initWithFrame:CGRectMake(53, 13, 240, 15)];
        _nickname.textColor = UIColorFromRGB(0x666666);
        _nickname.font = [UIFont fontWithName:@"Helvetica-Bold" size:13];
        [_nickname setBackgroundColor:[UIColor clearColor]];
        [_nickname setText:note.creator.nickname];
        [self addSubview:_nickname];
        
        y = _nickname.frame.origin.y + _nickname.frame.size.height;
        
        RatingView *_ratingView = [[RatingView alloc]initWithFrame:CGRectZero];
        [_ratingView setImagesDeselected:@"star_s.png" partlySelected:@"star_s_half.png" fullSelected:@"star_s_full.png" andDelegate:nil];
        _ratingView.center = CGPointMake(_ratingView.center.x, 22);
        _ratingView.userInteractionEnabled = NO;
        [self addSubview:_ratingView];
        
        UILabel * _note = [[UILabel alloc]initWithFrame:CGRectMake(53,y+2,240,400)];
        _note.font = [UIFont fontWithName:@"STHeitiSC-Light" size:13];
        _note.numberOfLines = 0;
        _note.textAlignment = NSTextAlignmentLeft;
        _note.textColor = UIColorFromRGB(0x666666);
        _note.backgroundColor = [UIColor clearColor];
        _note.lineBreakMode = NSLineBreakByWordWrapping;
        [self addSubview:_note];
        
        UIFont *font = [UIFont fontWithName:@"Helvetica-Bold" size:13];
        CGSize size = [_nickname.text sizeWithFont:font constrainedToSize:CGSizeMake(250, CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping];
        _nickname.frame = CGRectMake(53, 13, size.width, size.height);
        
        _ratingView.frame = CGRectMake(53+size.width, 15,80 ,size.height);
        [_ratingView displayRating:note.score/2];
        
        font = [UIFont fontWithName:@"STHeitiSC-Light" size:13];
        size = [note.note sizeWithFont:font constrainedToSize:CGSizeMake(240, CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping];
        GKLog(@"%@",NSStringFromCGSize(size));
        [_note setFrame:CGRectMake(_note.frame.origin.x, _note.frame.origin.y, 240, size.height+5)];
        _note.text = note.note;


    }
}
-(void)showLikeUser
{
    int i = 0;
    for (GKUserBase * user in user_list) {
        GKUserButton *avatar = [[GKUserButton alloc]initWithFrame:CGRectMake(11+i*34,self.frame.size.height-40, 30, 30) useBg:NO cornerRadius:0];
        avatar.userBase = user;
        avatar.delegate = _delegate;
        [self addSubview:avatar];
        i++;
        if(i>=9)
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
