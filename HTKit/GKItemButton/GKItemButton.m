//
//  GKItemButton.m
//  Grape
//
//  Created by huiter on 13-4-29.
//  Copyright (c) 2013年 guoku. All rights reserved.
//

#import "GKItemButton.h"
#import "SDWebImagePrefetcher.h"
#import "GKDevice.h"
@implementation GKItemButton
{
@private
    UIImageView * _cardBgImg;
    ItemButtonType type;
    NSUInteger _entityid;
    NSURL *_imgURL;
    NSUInteger _padding;
    BOOL _useSmallImg;
}
@synthesize entity = _entity;
@synthesize note = _note;
@synthesize img = _img;
@synthesize itemImageButton = _itemImageButton;
@synthesize delegate = _delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        _useSmallImg = NO;
        _entityid = 0;
        type = kItemButtonWithNone;
        _padding = 8;
        self.img = [[UIImageView alloc] init];
        [_img setFrame:CGRectZero];
        [_img setContentMode:UIViewContentModeScaleAspectFit];
        [self addSubview:_img];
        
        _cardBgImg = [[UIImageView alloc] initWithFrame:CGRectZero];
        [_cardBgImg setImage:[[UIImage imageNamed:@"item_bg.png"] stretchableImageWithLeftCapWidth:2 topCapHeight:2]];
        [self insertSubview:_cardBgImg belowSubview:_img];
        
        _itemImageButton = [[UIButton alloc] initWithFrame:CGRectZero];

        [self addSubview:_itemImageButton];
        
    }
    return self;
}
- (void)setPadding:(NSUInteger)padding
{
    _padding = padding;
    [self setNeedsLayout];
}
- (void)setUseSmallImg:(BOOL)yes
{
    _useSmallImg = yes;
}
- (void)setEntity:(GKEntity *)data
{
     BOOL shouldreload = YES;
    if([data isKindOfClass:[GKEntity class]])
    {
        _entity = data;
        _entityid = data.entity_id;
        if([[NSUserDefaults standardUserDefaults] boolForKey:@"useBigImg"])
        {
            if([_imgURL isEqual:[NSURL URLWithString:[[data.imageURL absoluteString]stringByReplacingOccurrencesOfString:@"310x310" withString:@"640x640"]]])
            {
                shouldreload = NO;
            }
        }
        else
        {
            if([_imgURL isEqual:data.imageURL])
            {
                shouldreload = NO;
            }
        }
        _imgURL = data.imageURL;
        if([[NSUserDefaults standardUserDefaults] boolForKey:@"useBigImg"])
        {
        _imgURL = [NSURL URLWithString:[[data.imageURL absoluteString]stringByReplacingOccurrencesOfString:@"310x310" withString:@"640x640"]];
        }
        [_itemImageButton addTarget:self action:@selector(itemCardWithDataButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    if(shouldreload)
    {
        [self setNeedsLayout];
    }
}
- (void)setNote:(GKNote *)note
{
    BOOL shouldreload = YES;
    if([note isKindOfClass:[GKNote class]])
    {
        _note = note;
        _entityid = _note.entity_id;
        if([[NSUserDefaults standardUserDefaults] boolForKey:@"useBigImg"])
        {
            if([_imgURL isEqual:[NSURL URLWithString:[[_note.imageURL absoluteString]stringByReplacingOccurrencesOfString:@"310x310" withString:@"640x640"]]])
            {
                shouldreload = NO;
            }
        }
        else
        {
            if([_imgURL isEqual:_note.imageURL])
            {
                shouldreload = NO;
            }
        }
        _imgURL = _note.imageURL;
        if([[NSUserDefaults standardUserDefaults] boolForKey:@"useBigImg"])
        {
            _imgURL = [NSURL URLWithString:[[_imgURL absoluteString]stringByReplacingOccurrencesOfString:@"310x310" withString:@"640x640"]];
        }
        [_itemImageButton addTarget:self action:@selector(itemCardButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    if(shouldreload)
    {
    [self setNeedsLayout];
    }
}
- (void)setType:(ItemButtonType)data
{
    type = data;
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    _cardBgImg.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    _img.frame = CGRectMake(_cardBgImg.frame.origin.x+_padding,_cardBgImg.frame.origin.y+_padding , _cardBgImg.frame.size.width-_padding*2, _cardBgImg.frame.size.height-_padding*2);
    
    [_itemImageButton setFrame:_img.frame];
    if(_entityid != 0)
    {
        _itemImageButton.tag = _entityid;
        _itemImageButton.enabled = YES;
    }
    else
    {
        _itemImageButton.enabled = NO;
    }
    if (_useSmallImg) {

        NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
        NSLog(@"%@",[userDefault objectForKey:@"networkStatus"]);
        if([[userDefault objectForKey:@"networkStatus"]isEqualToString:@"WIFI"])
        {
            [[SDWebImagePrefetcher sharedImagePrefetcher]prefetchURLs:[NSArray arrayWithObject:_imgURL]];
        }
        _imgURL = [NSURL URLWithString:[[[_imgURL absoluteString]stringByReplacingOccurrencesOfString:@"310x310" withString:@"120x120"]stringByReplacingOccurrencesOfString:@"640x640" withString:@"120x120"]];
    }
    switch (type) {
        case kItemButtonWithNone:
        {
            [_img setImageWithURL:_imgURL];
        }
            break;
        case kItemButtonWithActivityIndicator:
        {
            __block UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
            activityIndicator.frame = CGRectMake(0, 0, 40, 40);
            activityIndicator.center = _img.center;
            activityIndicator.hidesWhenStopped = YES;
            activityIndicator.tag = 30325;
            activityIndicator.color = UIColorFromRGB(0x666666);
            [self insertSubview:activityIndicator belowSubview:_img];
            
            [activityIndicator startAnimating];
            [_img setImageWithURL:_imgURL placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
                [activityIndicator stopAnimating];
                [activityIndicator removeFromSuperview];
            }];
        }
            break;
        case kItemButtonWithNumProgress:
        {
            __block UILabel *progress = (UILabel *)[self viewWithTag:30326];
            __block UIImageView *block_img = _img;
            if(progress == nil)
            {
                progress = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 15)];
                progress.backgroundColor = [UIColor clearColor];
                progress.tag = 30326;
                progress.center = _img.center;
                progress.textAlignment = NSTextAlignmentCenter;
                progress.textColor = UIColorFromRGB(0x666666);
                progress.font = [UIFont fontWithName:@"Helvetica" size:12.0f];
            }
            [self addSubview:progress];
            [_img setImageWithURL:_imgURL placeholderImage:nil options:SDWebImageRetryFailed  progress:^(NSUInteger receivedSize, long long expectedSize) {
                float percentDone = fabsf((float)receivedSize*200/(receivedSize+expectedSize));
                if(expectedSize !=-1)
                [progress setText:[NSString stringWithFormat:@"%0.0f%%", percentDone]];
                            
            } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
                [progress removeFromSuperview];
                if (!error) {
                    if (image && cacheType == SDImageCacheTypeNone)
                    {
                        block_img.alpha = 0.0;
                        [UIView animateWithDuration:0.25
                                         animations:^{
                                             block_img.alpha = 1.0;
                                         }];
                    }
                }
            }];
        }
            break;
            
        default:
            [_img setImageWithURL:_imgURL];
            break;
    }
}
- (void)itemCardButtonAction:(id)sender
{
    UIButton *button = (UIButton *)sender;
    if (!button || ![button isKindOfClass:[UIButton class]])
        return;
    if (_delegate && [_delegate respondsToSelector:@selector(showDetailWithEntityID:)]) {
        [_delegate showDetailWithEntityID:button.tag];
    }
}
- (void)itemCardWithDataButtonAction:(id)sender
{
   // if (_delegate && [_delegate respondsToSelector:@selector(showDetailWithData:)]) {
    NSLog(@"%@",_delegate);
        [_delegate showDetailWithData:_entity];
    //}
}

@end
