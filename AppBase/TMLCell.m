//
//  TMLCell.m
//  MMM
//
//  Created by huiter on 13-6-20.
//  Copyright (c) 2013年 guoku. All rights reserved.
//

#import "TMLCell.h"
#import "TMLKeyWord.h"
#import "TMLCate.h"
#import "GKAppDelegate.h"
#import "TMLKeywordViewController.h"
@implementation TMLCell
{
@private
    UIView *bg;
    UIView * line;
    UIView * colorf9f9f9;
}
@synthesize delegate = _delegate;
@synthesize pid = _pid;
- (void)setDelegate:(id<GKDelegate>)delegate
{
    _delegate = delegate;
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.layer.masksToBounds = YES;
        bg = [[UIView alloc]initWithFrame:CGRectZero];
        bg.backgroundColor =UIColorFromRGB(0xebe7e4);
        bg.tag = 4001;
        [self addSubview:bg];
        
        line = [[UIView alloc]initWithFrame:CGRectZero];
        line.backgroundColor =UIColorFromRGB(0xe2ddd9);
        line.tag = 4002;
        [self addSubview:line];
        
        colorf9f9f9 = [[UIView alloc]initWithFrame:CGRectZero];
        colorf9f9f9.backgroundColor =UIColorFromRGB(0xf9f9f9);
        colorf9f9f9.tag = 4003;
        [self addSubview:colorf9f9f9];
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    UIImageView * entitybg = (UIImageView *)[self viewWithTag:3858];
    if(selected)
    {
        entitybg.image = [[UIImage imageNamed:@"tables_bottom_press.png"]stretchableImageWithLeftCapWidth:10 topCapHeight:10];
    }
    else
    {
        entitybg.image = [[UIImage imageNamed:@"tables_bottom.png"]stretchableImageWithLeftCapWidth:10 topCapHeight:10];
    }
    // Configure the view for the selected state
}
- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    [super setHighlighted:highlighted animated:animated];
    UIImageView * entitybg = (UIImageView *)[self viewWithTag:3858];
    if(highlighted)
    {
        entitybg.image = [[UIImage imageNamed:@"tables_bottom_press.png"]stretchableImageWithLeftCapWidth:10 topCapHeight:10];
    }
    else
    {
        entitybg.image = [[UIImage imageNamed:@"tables_bottom.png"]stretchableImageWithLeftCapWidth:10 topCapHeight:10];
    }
}
- (void)setObject:(NSObject *)object
{
    _object = object;
    [self setNeedsLayout];
}
- (void)layoutSubviews
{
    
    for(UIView * view in self.subviews)
    {
        if(view.tag<4000)
        {
            [view removeFromSuperview];
        }
    }
    
    bg.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    line.frame = CGRectMake(0,0, 2,self.frame.size.height);
    line.center = CGPointMake(20, line.center.y);
    colorf9f9f9.frame = CGRectMake(40,0,self.frame.size.width-40,self.frame.size.height);
    [super layoutSubviews];
    if ([_object isKindOfClass:[TMLKeyWord class]])
    {
        UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(50, 6, kScreenWidth-60, 44)];
        [button setImage:[UIImage imageNamed:@"arrow.png"] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"arrow_press.png"] forState:UIControlStateHighlighted];
        [button setBackgroundImage:[UIImage imageNamed:@"tables_single.png"] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageNamed:@"tables_single_press.png"]forState:UIControlStateHighlighted];
        button.titleLabel.font = [UIFont fontWithName:@"Helvetica" size:17.0f];
        [button.titleLabel setTextAlignment:NSTextAlignmentLeft];
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [button setImageEdgeInsets:UIEdgeInsetsMake(0, kScreenWidth-60-20, 0, 0)];
        [button setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
        [button setTitleColor:UIColorFromRGB(0x555555) forState:UIControlStateNormal];
        [button setTitle:((TMLKeyWord *)_object).name forState:UIControlStateNormal];
        [button addTarget:self action:@selector(goKeyWord) forControlEvents:UIControlEventTouchUpInside];
        
        UIFont *font = [UIFont fontWithName:@"Helvetica" size:17.0f];
        CGSize size = [((TMLKeyWord *)_object).name sizeWithFont:font constrainedToSize:CGSizeMake(240, CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping];


        if(((TMLKeyWord *)_object).count !=0)
        {

            UILabel *  count= [[UILabel alloc]initWithFrame:CGRectMake(size.width+22,14, 16, 16)];
            count.layer.masksToBounds = YES;
            count.layer.cornerRadius = 2.0;
            count.textAlignment = NSTextAlignmentCenter;
            count.backgroundColor =UIColorFromRGB(0xfecbc4);
            count.textColor = [UIColor whiteColor];
            count.text = [NSString stringWithFormat:@"%u",((TMLKeyWord *)_object).count];
            count.font = [UIFont fontWithName:@"Helvetica" size:10.0f];
            [button addSubview:count];
            
            UIFont *font = [UIFont fontWithName:@"Helvetica" size:10.0f];
            CGSize size = [count.text sizeWithFont:font constrainedToSize:CGSizeMake(240, CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping];
            count.frame = CGRectMake(count.frame.origin.x, count.frame.origin.y, size.width+12, count.frame.size.height);
            
        }
        
        
        if(((TMLKeyWord *)_object).necessary == YES)
        {
               UILabel *  necessary= [[UILabel alloc]initWithFrame:CGRectMake(button.frame.size.width-55,14, 25, 15)];
               necessary.layer.masksToBounds = YES;
               necessary.layer.cornerRadius = 2.0;
               necessary.textAlignment = NSTextAlignmentCenter;
               necessary.backgroundColor =UIColorFromRGB(0xed5c49);
               necessary.textColor = [UIColor whiteColor];
                necessary.text = @"必备";
               necessary.font = [UIFont fontWithName:@"Helvetica" size:10.0f];
               [button addSubview:necessary];
        }
           
        [self addSubview:button];
    }
    else if([_object isKindOfClass:[GKEntity class]])
    {
        UIImageView * entitybg = [[UIImageView alloc]initWithFrame:CGRectMake(50, 0, kScreenWidth-60, 98)];
        entitybg.image = [[UIImage imageNamed:@"tables_bottom.png"] stretchableImageWithLeftCapWidth:10 topCapHeight:10];
        entitybg.tag = 3858;
        [self addSubview:entitybg];
        GKEntity * _entity = (GKEntity*)_object;
        
        GKItemButton *_entityImageView = [[GKItemButton alloc] initWithFrame:CGRectZero];
        _entityImageView.entity = (GKEntity*)_object;
        [_entityImageView setFrame:CGRectMake(55, 5, 80, 80)];
        [self addSubview:_entityImageView];
        _entityImageView.delegate = self.delegate;
        
        UIImageView * check = [[UIImageView alloc]initWithFrame:CGRectMake(entitybg.frame.size.width-21, 0,20, 20)];
        check.image = [UIImage imageNamed:@"done.png"];
        if(_entity.my_score >0)
        {
            [entitybg addSubview:check];
        }
        
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
        
        UILabel *_price = [[UILabel alloc]initWithFrame:CGRectZero];
        _price.backgroundColor = [UIColor clearColor];
        
        _price.font = [UIFont fontWithName:@"Georgia" size:12.0f];
        _price.textAlignment = NSTextAlignmentLeft;
        _price.textColor = UIColorFromRGB(0x666666);
        [self addSubview:_price];
        
        CGFloat y = 10;
        if( !([_entity.brand isEqualToString:@""])) {
            _brand.frame = CGRectMake(150, y, 145, 15);
            y = _brand.frame.origin.y+_brand.frame.size.height;
        }
        _title.frame = CGRectMake(150, y, 145, 15);
        y = _title.frame.origin.y+_title.frame.size.height+10;
        _price.frame = CGRectMake(150, y, 145, 20);
        
        _brand.text = _entity.brand;
        _title.text = _entity.title;
        if(_entity.price != 0)
        {
            NSString * priceTitle = [NSString stringWithFormat:@"￥%.2f", _entity.price];
            _price.text = priceTitle ;
        }
    }
}
- (void)goKeyWord
{
    TMLKeywordViewController *VC = [[TMLKeywordViewController alloc] initWithPid:_pid Category:((TMLKeyWord *)_object)];
    VC.hidesBottomBarWhenPushed = YES;
    [((GKAppDelegate *)[UIApplication sharedApplication].delegate).drawerController closeDrawerAnimated:YES completion:^(BOOL finished) {
        [((GKNavigationController *)((GKAppDelegate *)[UIApplication sharedApplication].delegate).drawerController.centerViewController) pushViewController:VC  animated:YES];
    }];
}

@end
