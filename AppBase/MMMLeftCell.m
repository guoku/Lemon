//
//  MMMLeftCell.m
//  MMM
//
//  Created by huiter on 13-6-27.
//  Copyright (c) 2013年 guoku. All rights reserved.
//

#import "MMMLeftCell.h"

@implementation MMMLeftCell
{
 @private
    UIButton *label;
    UILabel * count;
}
@synthesize data = _data;


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.textLabel.highlightedTextColor = UIColorFromRGB(0x777777);
       label  = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 260, 44)];
        label.tag = 4001;

        [label.titleLabel setFont:[UIFont fontWithName:@"Helvetica" size:15.0f]];
        [label.titleLabel setTextAlignment:UITextAlignmentLeft];
        [label setImageEdgeInsets:UIEdgeInsetsMake(1, 10, 0, 0)];
        [label setTitleEdgeInsets:UIEdgeInsetsMake(0, 15, 0, 0)];
        label.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        label.userInteractionEnabled = NO;
        
        //[label setBackgroundImage:[UIImage imageNamed:@"363131.png"] forState:UIControlStateNormal];
        //[label setBackgroundImage:[[UIImage imageNamed:@"bg363131.png"]stretchableImageWithLeftCapWidth:10 topCapHeight:10 ] forState:UIControlStateNormal|UIControlStateHighlighted];
        count= [[UILabel alloc]initWithFrame:CGRectZero];
        count.tag = 4002;
        count.layer.masksToBounds = YES;
        count.layer.cornerRadius = 2.0;
        count.textAlignment = UITextAlignmentCenter;
        count.backgroundColor = UIColorFromRGB(0x5E5757);
        count.textColor = [UIColor whiteColor];
        count.font = [UIFont fontWithName:@"Helvetica" size:12.0f];
        [label addSubview:count];
        [self addSubview:label];

        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    if(selected)
    {
        [self viewWithTag:4003].hidden = YES;
        self.backgroundColor = UIColorFromRGB(0x363131);
    }
    else
    {
        [self viewWithTag:4003].hidden = NO;
        self.backgroundColor = UIColorFromRGB(0x403B3B);
    }
    // Configure the view for the selected state
}
- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    [super setHighlighted:highlighted animated:animated];
    if(highlighted)
    {
        [self viewWithTag:4003].hidden = YES;
        self.backgroundColor = UIColorFromRGB(0x363131);
    }
    else
    {
        [self viewWithTag:4003].hidden = NO;
        self.backgroundColor = UIColorFromRGB(0x403B3B);
    }
}
- (void)setData:(NSDictionary *)data
{
    _data = data;
    [self setNeedsLayout];
}
- (void)layoutSubviews
{

    [label setTitle:[_data objectForKey:@"name"] forState:UIControlStateNormal];
 
    
    if([[_data objectForKey:@"open"]boolValue])
    {
        [label setImage:[UIImage imageNamed:[NSString stringWithFormat:@"stage_%@.png",[_data objectForKey:@"pid"]]] forState:UIControlStateNormal];
        [label setTitleColor:UIColorFromRGB(0xFFFFFF) forState:UIControlStateNormal];
    }
    else
    {
        [label setImage:[UIImage imageNamed:[NSString stringWithFormat:@"stage_comp_%@.png",[_data objectForKey:@"pid"]]] forState:UIControlStateNormal];
        [label setTitleColor:UIColorFromRGB(0x777777) forState:UIControlStateNormal];
    }
    
    if([[_data objectForKey:@"count"]intValue] >0)
    {
        UIFont *font = [UIFont fontWithName:@"Helvetica" size:12];
        
        CGSize size = [[_data objectForKey:@"count"] sizeWithFont:font constrainedToSize:CGSizeMake(250, 15) lineBreakMode:NSLineBreakByWordWrapping];
        [count setText:[_data objectForKey:@"count"]];
        count.frame = CGRectMake(260-size.width-30,11,size.width+10,20);
    }

}
@end
