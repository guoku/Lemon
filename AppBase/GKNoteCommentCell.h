//
//  GKNoteCommentCell.h
//  Grape
//
//  Created by huiter on 13-3-30.
//  Copyright (c) 2013年 guoku. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GKComment.h"
#import "GKNoteLabel.h"
@interface GKNoteCommentCell : UITableViewCell

@property (nonatomic, strong) GKComment * data;
@property (strong, nonatomic) UIButton *avatarButton;
@property (strong, nonatomic) GKUserButton *avatar;
@property (strong, nonatomic) UILabel *nickname;
@property (strong, nonatomic) GKNoteLabel *comment;
@property (strong, nonatomic) UIButton *time;
@property (strong, nonatomic) UIImageView *seperatorLineImageView;
@property (weak,nonatomic) id<GKDelegate> delegate;
+ (float)height:(GKComment *)data;

@end
