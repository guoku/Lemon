//
//  TableViewCellForThree.h
//  Grape
//
//  Created by huiter on 13-4-9.
//  Copyright (c) 2013年 guoku. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SimpleCardView.h"

@interface TableViewCellForThree : UITableViewCell

@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) SimpleCardView * firstCardView;
@property (nonatomic, strong) SimpleCardView * secondCardView;
@property (nonatomic, strong) SimpleCardView * threeCardView;
@property (nonatomic, weak) id<GKDelegate> delegate;

@end
