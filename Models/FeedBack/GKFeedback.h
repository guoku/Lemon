//
//  GKFeedback.h
//  Grape
//
//  Created by 谢 家欣 on 13-4-23.
//  Copyright (c) 2013年 guoku. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GKFeedback : NSObject


+ (void)postFeedBackWittContent:(NSString *)content Block:(void (^)(BOOL is_success, NSError * error))block;
@end
