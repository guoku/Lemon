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
        _img = [[GKItemButton alloc] initWithFrame:CGRectMake(5, 0, 145, 145)];
        [_img setType:kItemButtonWithNumProgress];
        [self addSubview:_img];
        

        y = _img.frame.origin.y+_img.frame.size.height;
        
        self.rating = [[RatingView alloc]initWithFrame:CGRectZero];
        _rating.frame = CGRectMake(0, y, 70, 10);
    [_rating setImagesDeselected:@"star_s.png" partlySelected:@"star_s_half.png" fullSelected:@"star_s_full.png" andDelegate:nil];
        _rating.userInteractionEnabled = NO;
        _rating.center = CGPointMake(frame.size.width/2, _rating.center.y);
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
    _title.frame = CGRectMake(5, y, 145, 20);
    y = _title.frame.origin.y+_title.frame.size.height;
    _price.frame = CGRectMake(5, y, 145, 20);
    
    _img.entity = _entity;
    _likeButton.data = _entity;
    [_rating displayRating:7.0/2];
    _brand.text = _entity.brand;
    _title.text = _entity.title;
    NSString * priceTitle = [NSString stringWithFormat:@"￥%.2f", _entity.price];
    _price.text = priceTitle ;

}
@end
