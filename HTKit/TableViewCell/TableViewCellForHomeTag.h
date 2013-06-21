//
//  TableViewCellForUserTag.h
//  Grape
//
//  Created by huiter on 13-4-15.
//  Copyright (c) 2013年 guoku. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GKTags.h"

@interface TableViewCellForHomeTag : UITableViewCell

@property (nonatomic, strong) GKTags *data;
@property (strong, nonatomic) UILabel *tagLabel;
@property (strong, nonatomic) UILabel *tagNum;
@property (nonatomic, weak) id<GKDelegate> delegate;
@end
