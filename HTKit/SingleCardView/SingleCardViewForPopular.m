//
//  FavSingleCardView.m
//  果库2.0
//
//  Created by huiter on 13-1-4.
//  Copyright (c) 2013年 果库. All rights reserved.
//

#import "SingleCardViewForPopular.h"

@implementation SingleCardViewForPopular
{
@private
    CGFloat y;
}

@synthesize img =_img;
@synthesize likeButton = _likeButton;
@synthesize rating = _rating;
@synthesize brand = _brand;
@synthesize title = _title;
@synthesize price = _price;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _img = [[GKItemButton alloc] initWithFrame:CGRectMake(5, 5, 145, 145)];
        [_img setType:kItemButtonWithActivityIndicator];
        [self addSubview:_img];
        

        y = _img.frame.origin.y+_img.frame.size.height;
        
        self.rating = [[RatingView alloc]initWithFrame:CGRectZero];
        _rating.frame = CGRectMake(0, y, 70, 10);
    [_rating setImagesDeselected:@"star_s.png" partlySelected:@"star_s_half.png" fullSelected:@"star_s_full.png" andDelegate:nil];
        _rating.userInteractionEnabled = NO;
        _rating.center = CGPointMake(frame.size.width/2, _rating.center.y+5);
        [self addSubview:_rating];

        
        
        self.brand = [[UILabel alloc]initWithFrame:CGRectZero];
        _brand.backgroundColor = [UIColor clearColor];

        _brand.font = [UIFont fontWithName:@"Helvetica-Bold" size:12.0f];
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
     
        _price.font = [UIFont fontWithName:@"Georgia" size:12.0f];
        _price.textAlignment = NSTextAlignmentCenter;
        _price.textColor = UIColorFromRGB(0x666666);
        [self addSubview:_price];        
    }
    return self;
}
- (void)setEntity:(GKEntity *)data
{
    if([data isKindOfClass:[GKEntity class]])
    {
        _entity = data;
        [self setNeedsLayout];
    }
}
- (void)setDelegate:(id<GKDelegate>)delegate
{
    _delegate = delegate;
    _img.delegate = _delegate;
}
- (void)layoutSubviews
{
    y = _rating.frame.origin.y+_rating.frame.size.height;
    if( !([_entity.brand isEqualToString:@""])) {
        _brand.frame = CGRectMake(5, y, 145, 20);
        y = _brand.frame.origin.y+_brand.frame.size.height;
    }
    _title.frame = CGRectMake(5, y, 145, 15);
    y = _title.frame.origin.y+_title.frame.size.height;
    _price.frame = CGRectMake(5, y+5, 145, 15);
    
    _img.entity = _entity;
    _likeButton.data = _entity;
    [_rating displayRating:_entity.avg_score/2];
    _brand.text = _entity.brand;
    _title.text = _entity.title;
    NSString * priceTitle = [NSString stringWithFormat:@"￥%.2f", _entity.price];
    _price.text = priceTitle ;
    
    if(_entity.entitylike.status)
    {
        UIImageView * like = [[UIImageView alloc]initWithFrame:CGRectMake(_img.frame.size.width-21, 1,20, 20)];
        like.image = [UIImage imageNamed:@"listview_liked.png"];
        like.tag = 9999;
        [_img addSubview:like];


        /*
        UILabel *  necessary= [[UILabel alloc]initWithFrame:CGRectMake(_img.frame.size.width-42, 6, 38, 16)];
        necessary.layer.masksToBounds = YES;
        necessary.layer.cornerRadius = 2.0;
        necessary.tag = 9999;
        necessary.textAlignment = NSTextAlignmentCenter;
        necessary.backgroundColor =UIColorFromRGB(0xed5c49);
        necessary.textColor = [UIColor whiteColor];
        necessary.text = @"已收藏";
        necessary.font = [UIFont fontWithName:@"Helvetica" size:10.0f];
        [_img addSubview:necessary];
        */
    }
    else
    {
        [[_img viewWithTag:9999]removeFromSuperview];
        
    }

}
@end
