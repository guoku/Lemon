//
//  TableViewCellForMessage.h
//  Grape
//
//  Created by huiter on 13-4-19.
//  Copyright (c) 2013年 guoku. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GKMessages.h"
#import "RTLabel.h"

@interface TableViewCellForMessage : UITableViewCell<RTLabelDelegate>
@property (nonatomic, strong) GKMessages * message;
@property (nonatomic, weak) id<GKDelegate> delegate;
+ (float)height:(GKMessages *)message;
@end
