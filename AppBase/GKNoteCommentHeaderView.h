//
//  GKNoteCommentHeaderView.h
//  Grape
//
//  Created by huiter on 13-3-30.
//  Copyright (c) 2013年 guoku. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NoteCellDelegate.h"
#import "GKNoteLabel.h"

@interface GKNoteCommentHeaderView : UIView
@property (nonatomic, strong) GKNote * noteData;
@property (strong, nonatomic) UIButton *avatarButton;
@property (strong, nonatomic) GKUserButton *avatar;
@property (strong, nonatomic) UILabel *nickname;
@property (nonatomic, strong) GKNoteLabel * note;
@property (strong, nonatomic) UIButton *time;
@property (strong, nonatomic) UIButton *commentButton;
@property (strong, nonatomic) UIImageView *bg;
@property (strong, nonatomic) UIImageView * seperatorLineImageView;
@property (weak,nonatomic) id<GKDelegate> delegate;
+ (float)height:(GKNote *)data;
@end
