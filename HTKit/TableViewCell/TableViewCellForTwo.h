//
//  FavTableViewCell.h
//  果库2.0
//
//  Created by huiter on 13-1-4.
//  Copyright (c) 2013年 果库. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SingleCardViewForPopular.h"

@interface TableViewCellForTwo : UITableViewCell

@property (nonatomic, strong) SingleCardViewForPopular *firstCardView;
@property (nonatomic, strong) SingleCardViewForPopular *secondCardView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic,weak) id <GKDelegate> delegate;

@end
