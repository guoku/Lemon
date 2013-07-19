//
//  TableViewCellForMMMFS.h
//  MMM
//
//  Created by huiter on 13-7-20.
//  Copyright (c) 2013年 guoku. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MMMKWDFS.h"
#import "RatingView.h"

@interface TableViewCellForMMMFS : UITableViewCell

@property (nonatomic, strong) GKItemButton *img;
@property (nonatomic, strong) RatingView * rating;
@property (nonatomic, strong) UILabel * brand;
@property (nonatomic, strong) UILabel * title;
@property (nonatomic, strong) UILabel * price;
@property (nonatomic, strong) GKLikeButton *likeButton;
@property (nonatomic,weak) id<GKDelegate> delegate;
@property (nonatomic, strong) MMMKWDFS * data;
+ (float)height:(MMMKWDFS *)data;
@end
