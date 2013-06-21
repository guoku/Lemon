//
//  GKSelection.h
//  Grape
//
//  Created by 谢家欣 on 13-3-20.
//  Copyright (c) 2013年 guoku. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GKEntity.h"

@interface GKSelection : GKEntity


+ (NSArray *)getSelectionFromSQLite;
+ (NSArray *)getAllSelectionFromSQLiteWithSize:(NSUInteger)size;
+ (void)globalSelectionsWithSize:(NSUInteger)s
                      PostBefore:(NSDate *)postbefore
                      CategoryID:(NSUInteger)category_id
                           Block:(void (^)(NSArray *selections, NSError * error))block;
+ (void)cancelRequestSelection;
@end
