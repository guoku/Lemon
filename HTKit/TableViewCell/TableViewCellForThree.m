//
//  TableViewCellForThree.m
//  Grape
//
//  Created by huiter on 13-4-9.
//  Copyright (c) 2013年 guoku. All rights reserved.
//

#import "TableViewCellForThree.h"
#import "SimpleCardView.h"

@implementation TableViewCellForThree

{
@private
    __strong NSMutableArray * _dataArray;
}
@synthesize firstCardView = _firstCardView;
@synthesize secondCardView = _secondCardView;
@synthesize threeCardView = _threeCardView;
@synthesize delegate = _delegate;


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.textLabel.adjustsFontSizeToFitWidth = YES;
        self.textLabel.textColor = [UIColor darkGrayColor];
        self.detailTextLabel.font = [UIFont systemFontOfSize:12.0f];
        self.detailTextLabel.numberOfLines = 0;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.firstCardView = [[SimpleCardView alloc] initWithFrame:CGRectMake(7, 6, 98, 98)];
        self.secondCardView = [[SimpleCardView alloc] initWithFrame:CGRectMake(111, 6, 98, 98)];
        self.threeCardView = [[SimpleCardView alloc] initWithFrame:CGRectMake(215, 6, 98, 98)];
    }
    [self addSubview:_firstCardView];
    [self addSubview:_secondCardView];
    [self addSubview:_threeCardView];
    
    return self;
}
- (void)setDelegate:(id<GKDelegate>)delegate
{
    _delegate = delegate;
    self.firstCardView.delegate =self.delegate;
    self.secondCardView.delegate = self.delegate;
    self.threeCardView.delegate = self.delegate;

}
- (void)setDataArray:(NSMutableArray *)dataArray
{
    _dataArray = dataArray;
    if ([_dataArray isKindOfClass:[NSMutableArray class]]) {
        if([_dataArray count] == 1)
        {
            [self.firstCardView setHidden:NO];
            [self.secondCardView setHidden:YES];
            [self.threeCardView setHidden:YES];
            self.firstCardView.data = [_dataArray objectAtIndex:0];
        }
        if([_dataArray count] == 2)
        {
            [self.firstCardView setHidden:NO];
            [self.secondCardView setHidden:NO];
            [self.threeCardView setHidden:YES];
            self.firstCardView.data =[_dataArray objectAtIndex:0];
            self.secondCardView.data =[_dataArray objectAtIndex:1];
        }
        if([_dataArray count] == 3)
        {
            [self.firstCardView setHidden:NO];
            [self.secondCardView setHidden:NO];
            [self.threeCardView setHidden:NO];
            self.firstCardView.data =[_dataArray objectAtIndex:0];
            self.secondCardView.data =[_dataArray objectAtIndex:1];
            self.threeCardView.data = [_dataArray objectAtIndex:2];
        }
    }
}
#pragma mark - layout subview
- (void)layoutSubviews
{
   
}
@end
