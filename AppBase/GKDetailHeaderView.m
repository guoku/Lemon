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
@synthesize delegate = _delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = kColorf9f9f9;
        
        //商品TITLE
        bg = [[UIView alloc]initWithFrame:CGRectZero];
        bg.backgroundColor = kColorf2f2f2;
        [self addSubview:bg];
        
        self.title = [[UILabel alloc]initWithFrame:CGRectZero];
        self.title.frame = CGRectMake(145, 10, 300, 30);
        _title.numberOfLines = 1;
        _title.textColor = kColor666666;
        _title.font = [UIFont fontWithName:@"Helvetica" size:13];
        _title.textAlignment = UITextAlignmentLeft;
        _title.backgroundColor = [UIColor clearColor];
    
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
        y = _entityImageView.frame.origin.y + _entityImageView.frame.size.height;

        self.likeButton = [[GKLikeButton alloc]initWithFrame:CGRectMake(15, y+14, 105,25)];
        [self addSubview:_likeButton];
        
        self.usedButton = [[UIButton alloc]initWithFrame:CGRectMake(130, y+14, 100, 25)];
        [_usedButton setTitle:@"用过" forState:UIControlStateNormal];
        [_usedButton setImage:[UIImage imageNamed:@"detail_icon_add.png"] forState:UIControlStateNormal];
        [_usedButton setImage:[UIImage imageNamed:@"detail_icon_add.png"] forState:UIControlStateHighlighted];
        [_usedButton setImageEdgeInsets:UIEdgeInsetsMake(2, 0, 0, 0)];
        [_usedButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 5, 0, 0)];
        [_usedButton addTarget:self action:@selector(showNotePostView) forControlEvents:UIControlEventTouchUpInside];
        [_usedButton.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:15.0f]];
        [_usedButton setTitleColor:kColor666666 forState:UIControlStateNormal];
        [_usedButton setTitleColor:kColor666666 forState:UIControlStateHighlighted];
        [_usedButton setBackgroundImage:[[UIImage imageNamed:@"detail_cell_bottom"]stretchableImageWithLeftCapWidth:10 topCapHeight:1 ] forState:UIControlStateNormal];
        [_usedButton setBackgroundImage:[[UIImage imageNamed:@"detail_cell_bottom"]stretchableImageWithLeftCapWidth:10 topCapHeight:1 ] forState:UIControlStateHighlighted];
        
        [self addSubview:_usedButton];
        
        //Buy button
        self.buyInfoButton = [[UIButton alloc]initWithFrame:CGRectMake(200, y + 10, 110, 30)];
        UIEdgeInsets insets = UIEdgeInsetsMake(10, 10, 10, 10);
        [_buyInfoButton setBackgroundImage:[[UIImage imageNamed:@"green_btn_bg.png"]resizableImageWithCapInsets:insets] forState:UIControlStateNormal];
        [_buyInfoButton.titleLabel setFont:[UIFont fontWithName:@"Georgia" size:18]];
        [_buyInfoButton.titleLabel setTextAlignment:UITextAlignmentLeft];
        [_buyInfoButton addTarget:self action:@selector(buyButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_buyInfoButton];
        
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
#pragma mark - button action
- (void)buyButtonAction:(id)sender
{
    if (_delegate && [_delegate respondsToSelector:@selector(showWebViewWithTaobaoUrl:)]) {
        [_delegate showWebViewWithTaobaoUrl:_detailData.urlString];
    }
}

#pragma mark -
- (void)layoutSubviews
{
    [super layoutSubviews];
    bg.frame =CGRectMake(0, 0, self.frame.size.width, self.frame.size.height-5);
    self.title.text = _detailData.title;
    _likeButton.data = _detailData;
    _entityImageView.entity = _detailData;


    NSString * priceTitle = [NSString stringWithFormat:@"￥%.2f", _detailData.price];
    NSString * liked_count = [NSString stringWithFormat:@"%u 个喜爱", _detailData.liked_count];
    [_likeButton.likeButton setTitle:liked_count forState:UIControlStateNormal];
    [_buyInfoButton setTitle:priceTitle forState:UIControlStateNormal];
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
    [((GKAppDelegate *)[UIApplication sharedApplication].delegate).drawerController closeDrawerAnimated:YES completion:^(BOOL finished) {
        [((GKNavigationController *)((GKAppDelegate *)[UIApplication sharedApplication].delegate).drawerController.centerViewController) pushViewController:VC  animated:YES];
    }];
}
@end
