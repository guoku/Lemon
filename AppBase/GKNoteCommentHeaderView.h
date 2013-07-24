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
#import "RatingView.h"

@interface GKNoteCommentHeaderView : UIView
@property (nonatomic,strong) GKEntity * entity;
@property (nonatomic, strong) GKNote * noteData;


@property (nonatomic, strong) UILabel * brand;
@property (nonatomic, strong) UILabel * title;
@property (nonatomic,strong)  RatingView * ratingView;
@property (nonatomic, strong) GKItemButton *entityImageView;
@property (nonatomic,strong) UIButton * entityButton;
@property (nonatomic,strong) UILabel *score;
@property (nonatomic,strong) NSMutableArray * poke_user_list;


@property (strong, nonatomic) UIButton *avatarButton;
@property (strong, nonatomic) GKUserButton *avatar;
@property (strong, nonatomic) UILabel *nickname;
@property (nonatomic,strong)  RatingView * noteRatingView;
@property (nonatomic, strong) UILabel * note;
@property (strong, nonatomic) UIButton *time;
@property (strong, nonatomic) UIButton *pokeButton;
@property (weak,nonatomic) id<NoteCellDelegate> notedelegate;
@property (strong, nonatomic) UIImageView * seperatorLineImageView;
@property (weak,nonatomic) id<GKDelegate> delegate;
- (void)setNoteData:(GKNote *)noteData entityData:(GKEntity *)entity;
+ (float)height:(GKNote *)data;
@end
