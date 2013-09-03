//
//  FavTableViewCell.m
//  妈妈清单2.0
//
//  Created by huiter on 13-1-4.
//  Copyright (c) 2013年 妈妈清单. All rights reserved.
//

#import "TableViewCellForTwo.h"

@implementation TableViewCellForTwo
{
@private
    __strong NSMutableArray * _dataArray;
}
@synthesize firstCardView = _firstCardView;
@synthesize secondCardView = _secondCardView;
@synthesize delegate = _delegate;


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.textLabel.adjustsFontSizeToFitWidth = YES;
        self.textLabel.textColor = [UIColor darkGrayColor];
        self.detailTextLabel.font = [UIFont systemFontOfSize:12.0f];
        self.detailTextLabel.numberOfLines = 0;
        self.selectionStyle = UITableViewCellSelectionStyleGray;

        self.firstCardView = [[SingleCardViewForPopular alloc] initWithFrame:CGRectMake(5, 0, 155, 175)];
        self.secondCardView = [[SingleCardViewForPopular alloc] initWithFrame:CGRectMake(160, 0, 155, 175)];

    }
    [self addSubview:_firstCardView];
    [self addSubview:_secondCardView];
    
    return self;
}
- (void)setDelegate:(id<GKDelegate>)delegate
{
    _delegate = delegate;
    self.firstCardView.delegate = self.delegate;
    self.secondCardView.delegate = self.delegate;
}
- (void)setDataArray:(NSMutableArray *)dataArray
{
    _dataArray = dataArray;
    if ([_dataArray isKindOfClass:[NSMutableArray class]]) {
        if([_dataArray count] == 1)
        {
            [self.firstCardView setHidden:NO];
            [self.secondCardView setHidden:YES];
            self.firstCardView.entity = [_dataArray objectAtIndex:0];
        }
        if([_dataArray count] == 2)
        {
            [self.firstCardView setHidden:NO];
            [self.secondCardView setHidden:NO];
            self.firstCardView.entity =[_dataArray objectAtIndex:0];
            self.secondCardView.entity =[_dataArray objectAtIndex:1];

        }
    }
}
#pragma mark - layout subview
- (void)layoutSubviews
{
}
@end
