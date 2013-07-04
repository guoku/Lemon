//
//  TableViewCellForUserTag.m
//  Grape
//
//  Created by huiter on 13-4-15.
//  Copyright (c) 2013年 guoku. All rights reserved.
//

#import "TableViewCellForHomeTag.h"
@implementation TableViewCellForHomeTag

{
@private
    __strong GKTags *_data;
    __strong NSMutableArray * _dataArray;
}
@synthesize tagLabel = _tagLabel;
@synthesize tagNum = _tagNum;
@synthesize delegate = _delegate;


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
    
        self.textLabel.adjustsFontSizeToFitWidth = YES;
        self.textLabel.textColor = [UIColor darkGrayColor];
        self.detailTextLabel.font = [UIFont systemFontOfSize:12.0f];
        self.detailTextLabel.numberOfLines = 0;
        
        self.tagLabel = [[UILabel alloc]initWithFrame:CGRectMake(8, 14, 300, 20)];
        [_tagLabel setAdjustsFontSizeToFitWidth:NO];
        [_tagLabel setNumberOfLines:1];
        [_tagLabel setBackgroundColor:[UIColor clearColor]];
        [_tagLabel setLineBreakMode:UILineBreakModeTailTruncation];
        [_tagLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:13.0f]];
        [_tagLabel setTextColor:UIColorFromRGB(0x666666)];
        [_tagLabel setTextAlignment:NSTextAlignmentLeft];
        [self addSubview:_tagLabel];
        
        
        self.tagNum = [[UILabel alloc]initWithFrame:CGRectZero];
        [_tagNum setAdjustsFontSizeToFitWidth:NO];
        [_tagNum setNumberOfLines:1];
        [_tagNum setBackgroundColor:[UIColor clearColor]];
        [_tagNum setLineBreakMode:UILineBreakModeTailTruncation];
        [_tagNum setFont:[UIFont fontWithName:@"Helvetica" size:12.0f]];
        [_tagNum setTextColor:UIColorFromRGB(0x666666)];
        [_tagNum setTextAlignment:NSTextAlignmentLeft];
        [self addSubview:_tagNum];
        
        UIImageView *icon = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"home_cell_bg_icon.png"]];
        icon.frame = CGRectMake(kScreenWidth-100, 10, 93, 38);
        [self addSubview:icon];
        
        UIImageView *arrow = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"arrow_right.png"]];
        arrow.frame = CGRectMake(kScreenWidth-30, 20, 10, 14);
        [self addSubview:arrow];
        
        
        UIImageView * _seperatorLineImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 2)];
        [_seperatorLineImageView setImage:[UIImage imageNamed:@"splitline.png"]];
        [self addSubview:_seperatorLineImageView];
    }
    return self;
}
- (void)setDelegate:(id<GKDelegate>)delegate
{
    _delegate = delegate;
    for (UIView *view in self.subviews) {
        if([view isKindOfClass:[GKItemButton class]])
        {
            GKItemButton *itembutton = (GKItemButton *)view;
            itembutton.delegate = _delegate;
        }
    }
    
}
- (void)setData:(GKTags *)data
{
    _data = data;
    if ([data isKindOfClass:[GKTags class]]) {
    _dataArray = data.previews;
    }
    [self setNeedsLayout];
}

#pragma mark - layout subview
- (void)layoutSubviews
{
    for (UIView *view in self.subviews) {
        if([view isKindOfClass:[GKItemButton class]])
           [view removeFromSuperview];
    }
    [_tagLabel setText:[NSString stringWithFormat:@"#%@",_data.tag_name]];
    UIFont *font = [UIFont fontWithName:@"Helvetica-Bold" size:13];
    CGSize labelsize = [_tagLabel.text sizeWithFont:font constrainedToSize:CGSizeMake(300, 20) lineBreakMode:NSLineBreakByWordWrapping];
    
    [_tagLabel setFrame:CGRectMake(_tagLabel.frame.origin.x, 17, labelsize.width,20)];
    if(labelsize.width>220)
    {
            [_tagLabel setFrame:CGRectMake(_tagLabel.frame.origin.x, 10,220,20)];
    }
    [_tagNum setText:[NSString stringWithFormat:@" %u件商品",[_data.previews count]]];
    [_tagNum setFrame:CGRectMake(_tagLabel.frame.origin.x+_tagLabel.frame.size.width, _tagLabel.frame.origin.y,80,20)];

    self.selectedBackgroundView.frame =CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    
    if(_dataArray!=nil)
    {
        int i =0;
        for (GKEntity *entity in _dataArray) {
            GKItemButton *item_button = [[GKItemButton alloc]initWithFrame:CGRectMake(10+i*75, 42, 72, 72)];
            [item_button setUseSmallImg:YES];
            [item_button setPadding:4];
            item_button.entity = entity;
            [self addSubview:item_button];
            i++;
            if(i>=4)
            {
                break;
            }
        }
    }
    self.delegate = _delegate;
}

@end
