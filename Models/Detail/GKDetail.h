//
//  GKDetail.h
//  Grape
//
//  Created by 谢家欣 on 13-3-21.
//  Copyright (c) 2013年 guoku. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import "GKNote.h"
#import "GKEntity.h"


@interface GKDetail : GKEntity

@property (strong,nonatomic) NSMutableArray * liker_list;

+ (void)globalDetailPageWithEntityId:(NSUInteger)entity_id
                               Block:(void (^)(NSDictionary * dict, NSError * error))block;
+ (void)EntityRecommendWithEntityID:(NSUInteger)entity_id
                              Block:(void (^)(NSArray * entitylist, NSError * error))block;
@end
