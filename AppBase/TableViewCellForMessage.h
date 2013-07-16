//
//  TableViewCellForMessage.h
//  Grape
//
//  Created by huiter on 13-4-19.
//  Copyright (c) 2013年 guoku. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GKMessages.h"

@interface TableViewCellForMessage : UITableViewCell
@property (nonatomic, strong) GKMessages * message;
@property (nonatomic, weak) id<GKDelegate> delegate;
+ (float)height:(GKMessages *)message;
@end
