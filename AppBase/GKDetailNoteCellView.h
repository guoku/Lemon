//
//  GKDetailNoteView.h
//  Grape
//
//  Created by huiter on 13-3-22.
//  Copyright (c) 2013年 guoku. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NoteCellDelegate.h"
#import "GKNoteLabel.h"
#import "RatingView.h"
@class GKNote;
@interface GKDetailNoteCellView : UITableViewCell

@property (nonatomic, strong) GKNote * noteData;
@property (nonatomic, strong) UIImageView *seperatorLineImageView;
@property (strong, nonatomic) UIButton *avatarButton;
@property (strong, nonatomic) GKUserButton *avatar;
@property (strong, nonatomic) UIButton *pokeButton;
@property (strong, nonatomic) UIButton * hootButton;
@property (strong, nonatomic) UIButton *commentButton;
@property (strong, nonatomic) UILabel *nickname;
@property (nonatomic, strong) UILabel * note;
@property (strong, nonatomic) UIButton *time;
@property (strong, nonatomic) RatingView *ratingView;

@property (weak,nonatomic) id<NoteCellDelegate> notedelegate;
@property (weak,nonatomic) id<GKDelegate> delegate;

+ (float)height:(GKNote *)data;
@end
