//
//  FeedbackTableViewCell.m
//  UMeng Analysis
//
//  Created by liuyu on 9/18/12.
//  Copyright (c) 2012 Realcent. All rights reserved.
//

#import "UMFeedbackTableViewCellLeft.h"

#define TOP_MARGIN 20.0f

@implementation UMFeedbackTableViewCellLeft

@synthesize timestampLabel = _timestampLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _avatar = [[UIImageView alloc]initWithFrame:CGRectMake(5, 34, 30, 30)];
        _avatar.image = [UIImage imageNamed:@"user_icon.png"];
        [self.contentView addSubview:_avatar];
        
        self.textLabel.backgroundColor = [UIColor clearColor];
        self.textLabel.font = [UIFont systemFontOfSize:14.0f];
        self.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
        self.textLabel.numberOfLines = 0;
        self.textLabel.textAlignment = UITextAlignmentLeft;
        self.textLabel.textColor = UIColorFromRGB(0x666666);

        _timestampLabel = [[UILabel alloc] init];
        _timestampLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        _timestampLabel.textAlignment = UITextAlignmentCenter;
        _timestampLabel.backgroundColor = UIColorFromRGB(0xe0e0e0);
        _timestampLabel.font = [UIFont systemFontOfSize:12.0f];
        _timestampLabel.textColor = UIColorFromRGB(0xffffff);
        _timestampLabel.frame = CGRectMake(130, 12, self.bounds.size.width-260, 18);

        [self.contentView addSubview:_timestampLabel];

        messageBackgroundView = [[UIImageView alloc] initWithFrame:self.textLabel.frame];
        messageBackgroundView.backgroundColor = [UIColor whiteColor];
        //messageBackgroundView.image = [[UIImage imageNamed:@"messages_left_bubble.png"] stretchableImageWithLeftCapWidth:20 topCapHeight:16];
        [self.contentView insertSubview:messageBackgroundView belowSubview:self.textLabel];

        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }

    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];

    CGRect textLabelFrame = self.textLabel.frame;
    textLabelFrame.origin.x = 50;
    textLabelFrame.size.width = 226;

    CGSize labelSize = [self.textLabel.text sizeWithFont:[UIFont systemFontOfSize:14.0f]
                                       constrainedToSize:CGSizeMake(226.0f, MAXFLOAT)
                                           lineBreakMode:UILineBreakModeWordWrap];

    textLabelFrame.size.height = labelSize.height;
    textLabelFrame.origin.y = 20.0f + TOP_MARGIN;
    self.textLabel.frame = textLabelFrame;

    messageBackgroundView.frame = CGRectMake(44, textLabelFrame.origin.y -6, labelSize.width +12, labelSize.height + 12);;
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
/*
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(context, [UIColor colorWithRed:0 green:0 blue:0 alpha:0.1].CGColor);

    CGContextSetLineWidth(context, 1.0);
    CGContextMoveToPoint(context, 0, 21); //start at this point
    CGContextAddLineToPoint(context, (self.bounds.size.width - 120) / 2, 21); //draw to this point

    CGContextMoveToPoint(context, self.bounds.size.width, 21); //start at this point
    CGContextAddLineToPoint(context, self.bounds.size.width - (self.bounds.size.width - 120) / 2, 21); //draw to this point

    CGContextStrokePath(context);
 */

}

@end
