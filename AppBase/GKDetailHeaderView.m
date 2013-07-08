//
//  GKDetailHeaderView.m
//  Grape
//
//  Created by huiter on 13-3-22.
//  Copyright (c) 2013年 guoku. All rights reserved.
//

#import "GKDetailHeaderView.h"
#import "GKAppDelegate.h"
#import "GKNotePostViewController.h"

#import "GKDetail.h"

@implementation GKDetailHeaderView {
@private
    __strong GKEntity * _detailData;
    __strong GKEntityLike * _entityLike;
    __strong NSMutableDictionary * _message;
    UIView *bg;
    CGFloat y;
}
@synthesize detailData = _detailData;

@synthesize title = _title;
@synthesize entityImageView= _entityImageView;
@synthesize likeButton = _likeButton;
@synthesize buyInfoButton = _buyInfoButton;
@synthesize buyInfoLabel = _buyInfoLabel;
@synthesize noteButton = _noteButton;
@synthesize usedButton = _usedButton;
@synthesize shareButton = _shareButton;
@synthesize delegate = _delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor =UIColorFromRGB(0xf2f2f2);
        
        //商品TITLE
        bg = [[UIView alloc]initWithFrame:CGRectZero];
        bg.backgroundColor =UIColorFromRGB(0xf2f2f2);
        [self addSubview:bg];
        
        self.brand = [[UILabel alloc]initWithFrame:CGRectZero];
        _brand.backgroundColor = [UIColor clearColor];
        _brand.font = [UIFont fontWithName:@"Helvetica" size:15.0f];
        _brand.textAlignment = NSTextAlignmentLeft;
        _brand.textColor =UIColorFromRGB(0x555555);
        [self addSubview:_brand];
        
        
        
        self.title = [[UILabel alloc]initWithFrame:CGRectZero];
        _title.backgroundColor = [UIColor clearColor];
        
        _title.font = [UIFont fontWithName:@"Helvetica" size:15.0f];
        _title.textAlignment = NSTextAlignmentLeft;
        _title.textColor =UIColorFromRGB(0x555555);
        [self addSubview:_title];
        
        
        
        self.price = [[UILabel alloc]initWithFrame:CGRectZero];
        _price.backgroundColor = [UIColor clearColor];
        
        _price.font = [UIFont fontWithName:@"Helvetica" size:15.0f];
        _price.textAlignment = NSTextAlignmentLeft;
        _price.textColor = UIColorFromRGB(0x666666);
        [self addSubview:_price];
    
        [self addSubview:_title];
        y = self.title.frame.origin.y+self.title.frame.size.height;
        
        
        //商品图片
        self.entityImageView = [[GKItemButton alloc] initWithFrame:CGRectZero];
        [_entityImageView setFrame:CGRectMake(5,10,125,125)];
        _entityImageView.userInteractionEnabled = NO;
        [self addSubview:_entityImageView];
        UIButton *showTaobao = [[UIButton alloc]initWithFrame:_entityImageView.frame];
        [showTaobao addTarget:self action:@selector(buyButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:showTaobao];
        
        self.buyInfoButton = [[UIButton alloc]initWithFrame:CGRectMake(220, 100, 80, 26)];
        UIEdgeInsets insets = UIEdgeInsetsMake(5, 15, 5, 5);
        [_buyInfoButton setBackgroundImage:[[UIImage imageNamed:@"button_buy.png"]resizableImageWithCapInsets:insets] forState:UIControlStateNormal];
        [_buyInfoButton setBackgroundImage:[[UIImage imageNamed:@"button_buy_press.png"]resizableImageWithCapInsets:insets] forState:UIControlStateHighlighted];
        [_buyInfoButton.titleLabel setFont:[UIFont fontWithName:@"Georgia" size:18]];
        [_buyInfoButton.titleLabel setTextAlignment:NSTextAlignmentLeft];
        [self addSubview:_buyInfoButton];
        
        y = _entityImageView.frame.origin.y + _entityImageView.frame.size.height;

        y = y+10;
        UIView *f9f9f9bg = [[UIView alloc]initWithFrame:CGRectMake(0, y, kScreenWidth, 60)];
        f9f9f9bg.backgroundColor = UIColorFromRGB(0xf9f9f9);
        [self addSubview:f9f9f9bg];
        
        self.likeButton = [[GKLikeButton alloc]initWithFrame:CGRectMake(8, y+14, 85,32)];
        [self addSubview:_likeButton];
        
        self.usedButton = [[UIButton alloc]initWithFrame:CGRectMake(100, y+14, 75, 32)];
        [_usedButton setTitle:@"用过" forState:UIControlStateNormal];
        [_usedButton setImage:[UIImage imageNamed:@"check_white.png"] forState:UIControlStateNormal];
        [_usedButton setImage:[UIImage imageNamed:@"check_white.png"] forState:UIControlStateNormal|UIControlStateHighlighted];
        [_usedButton setImage:[UIImage imageNamed:@"check_green.png"] forState:UIControlStateSelected];
        [_usedButton setImage:[UIImage imageNamed:@"check_green.png"] forState:UIControlStateHighlighted|UIControlStateSelected];
        [_usedButton setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
        [_usedButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 5, 0, 0)];
        [_usedButton addTarget:self action:@selector(showNotePostView) forControlEvents:UIControlEventTouchUpInside];
        [_usedButton.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:14.0f]];
        [_usedButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_usedButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        [_usedButton setBackgroundImage:[[UIImage imageNamed:@"button_green.png"]stretchableImageWithLeftCapWidth:10 topCapHeight:1 ] forState:UIControlStateNormal];
        [_usedButton setBackgroundImage:[[UIImage imageNamed:@"button_green_press.png"]stretchableImageWithLeftCapWidth:10 topCapHeight:1 ] forState:UIControlStateHighlighted];
        [_usedButton setBackgroundImage:[[UIImage imageNamed:@"button_normal.png"]stretchableImageWithLeftCapWidth:10 topCapHeight:1 ] forState:UIControlStateSelected];
        [_usedButton setBackgroundImage:[[UIImage imageNamed:@"button_normal_press.png"]stretchableImageWithLeftCapWidth:10 topCapHeight:1 ] forState:UIControlStateHighlighted|UIControlStateSelected];
        
        [self addSubview:_usedButton];
        
        self.shareButton = [[UIButton alloc]initWithFrame:CGRectMake(kScreenWidth-60, y+14, 50, 32)];
        [_shareButton setTitle:@"分享" forState:UIControlStateNormal];
        [_shareButton.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:14.0f]];
        [_shareButton setTitleColor:UIColorFromRGB(0x999999) forState:UIControlStateNormal];
        [_shareButton setTitleColor:UIColorFromRGB(0x999999) forState:UIControlStateHighlighted];
        [_shareButton setBackgroundImage:[[UIImage imageNamed:@"button_normal.png"]stretchableImageWithLeftCapWidth:10 topCapHeight:1 ] forState:UIControlStateNormal];
        [_shareButton setBackgroundImage:[[UIImage imageNamed:@"button_normal_press.png"]stretchableImageWithLeftCapWidth:10 topCapHeight:1 ] forState:UIControlStateHighlighted];
        
        [self addSubview:_shareButton];
        
        
        y = self.likeButton.frame.origin.y + self.likeButton.frame.size.height;
        
        _message = [[NSMutableDictionary alloc]init];
    }
    return self;
}

- (void)setDetailData:(GKEntity *)detailData
{

    if ([detailData isKindOfClass:[GKEntity class]]) {
            _detailData = detailData;
    }
    [self setNeedsLayout];
}
- (void)setDelegate:(id<GKDelegate>)delegate
{
    _delegate = delegate;
    _entityImageView.delegate = _delegate;    
}
#pragma mark -
- (void)layoutSubviews
{
    [super layoutSubviews];
    bg.frame =CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    y =10;
    if( !([_detailData.brand isEqualToString:@""])) {
        _brand.frame = CGRectMake(145, y, 145, 20);
        y = _brand.frame.origin.y+_brand.frame.size.height;
    }
    _title.frame = CGRectMake(145, y, 145, 20);
    y = _title.frame.origin.y+_title.frame.size.height+10;
    CGFloat remark_x = 0;
    CGFloat remark_y = 0;
    for (NSString * remark in _detailData.remark_list) {
        UIFont *font = [UIFont fontWithName:@"Helvetica" size:10.0f];
        CGSize size = [remark sizeWithFont:font constrainedToSize:CGSizeMake(CGFLOAT_MAX,10) lineBreakMode:NSLineBreakByTruncatingTail];
        UILabel *remarkLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        if(remark_x+size.width>160)
        {
            remark_x = 0;
            remark_y = remark_y+20;
            remarkLabel.frame = CGRectMake(145+remark_x,y+remark_y, size.width+2, 14);
            remark_x = remark_x+size.width+10;
            
        }
        else
        {
            remarkLabel.frame = CGRectMake(145+remark_x,y+remark_y, size.width+2, 14);
            remark_x = remark_x+size.width+10;
        }
        remarkLabel.layer.masksToBounds = YES;
        remarkLabel.layer.cornerRadius = 2.0;
        remarkLabel.textAlignment = NSTextAlignmentCenter;
        remarkLabel.backgroundColor = UIColorFromRGB(0xe0e0e0);
        remarkLabel.textColor = UIColorFromRGB(0x959595);
        remarkLabel.font = [UIFont fontWithName:@"Helvetica" size:10.0f];
        remarkLabel.text = remark;
        [self addSubview:remarkLabel];
    }
    
    
    
    
    _price.frame = CGRectMake(145, 100, 145, 20);
    
    _likeButton.data = _detailData;

    _brand.text = _detailData.brand;
    _title.text = _detailData.title;
    NSString * priceTitle = [NSString stringWithFormat:@"￥%.2f", _detailData.price];
    _price.text = priceTitle ;
    _likeButton.data = _detailData;
    _entityImageView.entity = _detailData;

    NSString * liked_count = [NSString stringWithFormat:@"%u 个喜爱", _detailData.liked_count];
    [_likeButton.likeButton setTitle:liked_count forState:UIControlStateNormal];
    [_buyInfoButton setTitle:@"去购买" forState:UIControlStateNormal];
    _buyInfoButton.userInteractionEnabled = YES;
}

- (UIImage *)image
{
    UIGraphicsBeginImageContext(CGSizeMake(310,310));
    [_entityImageView.img.image drawInRect:CGRectMake(0, 0, 310, 310)];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}

- (void)showNotePostView
{
    GKNotePostViewController *VC = [[GKNotePostViewController alloc] init];
    VC.hidesBottomBarWhenPushed = YES;
    GKNavigationController *nav = [[GKNavigationController alloc]initWithRootViewController:VC];
    [((GKAppDelegate *)[UIApplication sharedApplication].delegate).drawerController closeDrawerAnimated:YES completion:^(BOOL finished) {
        [((GKNavigationController *)((GKAppDelegate *)[UIApplication sharedApplication].delegate).drawerController.centerViewController) presentViewController:nav animated:YES completion:NULL];
    }];
}
@end
