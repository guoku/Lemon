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
        bg.backgroundColor = kColorebe7e4;
        bg.tag = 4001;
        [self addSubview:bg];
        
        line = [[UIView alloc]initWithFrame:CGRectZero];
        line.backgroundColor = kColore2ddd9;
        line.tag = 4002;
        [self addSubview:line];
        
        colorf9f9f9 = [[UIView alloc]initWithFrame:CGRectZero];
        colorf9f9f9.backgroundColor = kColorf9f9f9;
        colorf9f9f9.tag = 4003;
        [self addSubview:colorf9f9f9];
        
    }
    return self;
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
        UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(50, 0, kScreenWidth-60, 40)];
        [button setImage:[UIImage imageNamed:@"arrow.png"] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"arrow_press.png"] forState:UIControlStateHighlighted];
        [button setBackgroundImage:[UIImage imageNamed:@"tables_single.png"] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageNamed:@"tables_single_press.png"]forState:UIControlStateHighlighted];
        button.titleLabel.font = [UIFont fontWithName:@"Helvetica" size:17.0f];
        [button.titleLabel setTextAlignment:UITextAlignmentLeft];
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [button setImageEdgeInsets:UIEdgeInsetsMake(0, kScreenWidth-60-20, 0, 0)];
        [button setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
        [button setTitleColor:kColor555555 forState:UIControlStateNormal];
        [button setTitle:((TMLKeyWord *)_object).name forState:UIControlStateNormal];
        [button addTarget:self action:@selector(goKeyWord) forControlEvents:UIControlEventTouchUpInside];
        
        if(((TMLKeyWord *)_object).necessary == YES)
        {
               UILabel *  necessary= [[UILabel alloc]initWithFrame:CGRectMake(button.frame.size.width-55,13, 25, 15)];
               necessary.layer.masksToBounds = YES;
               necessary.layer.cornerRadius = 2.0;
               necessary.textAlignment = UITextAlignmentCenter;
               necessary.backgroundColor = kColored5c49;
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
        entitybg.image = [UIImage imageNamed:@"tables_bottom.png"];
        [self addSubview:entitybg];
        
        GKItemButton *_entityImageView = [[GKItemButton alloc] initWithFrame:CGRectZero];
        _entityImageView.entity = (GKEntity*)_object;
        [_entityImageView setFrame:CGRectMake(55, 5, 80, 80)];
        [self addSubview:_entityImageView];
        _entityImageView.delegate = self.delegate;
        
        UIImageView * check = [[UIImageView alloc]initWithFrame:CGRectMake(entitybg.frame.size.width-21, 0,20, 20)];
        check.image = [UIImage imageNamed:@"done.png"];
        [entitybg addSubview:check];
    }
    else if([_object isKindOfClass:[TMLCate class]])
    {
        UIButton * label = [[UIButton alloc]initWithFrame:CGRectMake(50, 0,kScreenWidth-60,20)];
        [label.titleLabel setFont:[UIFont fontWithName:@"Helvetica" size:10.0f]];
        [label setTitleColor:kColor555555 forState:UIControlStateNormal];
        label.backgroundColor = kColorf9f9f9;
        [label.titleLabel setTextAlignment:UITextAlignmentLeft];
        label.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [label setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
        [label setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
        label.userInteractionEnabled = NO;
        [label setTitle:((TMLCate *)_object).name forState:UIControlStateNormal];
        [self addSubview:label];
    }
    
}
- (void)goKeyWord
{
    TMLKeywordViewController *VC = [[TMLKeywordViewController alloc] init];
    VC.hidesBottomBarWhenPushed = YES;
    [((GKAppDelegate *)[UIApplication sharedApplication].delegate).drawerController closeDrawerAnimated:YES completion:^(BOOL finished) {
        [((GKNavigationController *)((GKAppDelegate *)[UIApplication sharedApplication].delegate).drawerController.centerViewController) pushViewController:VC  animated:YES];
    }];
}

@end
