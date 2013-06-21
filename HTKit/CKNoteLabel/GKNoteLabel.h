//
//  GKNoteLabel.h
//  Grape
//
//  Created by huiter on 13-4-29.
//  Copyright (c) 2013年 guoku. All rights reserved.
//

#import "TTTAttributedLabel.h"
#import "GKDelegate.h"
#import "GKComment.h"
@interface GKNoteLabel : UIView<TTTAttributedLabelDelegate,UIActionSheetDelegate,UIGestureRecognizerDelegate,UIActionSheetDelegate>
@property (nonatomic, strong) GKNote *note;
@property (nonatomic, strong) GKComment *comment;

@property (nonatomic, strong) TTTAttributedLabel * content;
@property (nonatomic,weak) id <GKDelegate> gkdelegate;
- (void)setFontsize:(NSUInteger)size;
@end
