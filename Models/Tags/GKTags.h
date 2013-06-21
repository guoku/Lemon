//
//  GKTags.h
//  Grape
//
//  Created by 谢 家欣 on 13-4-2.
//  Copyright (c) 2013年 guoku. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GKCreator.h"
@interface GKTags : NSObject

@property (readonly) NSString * tag_name;
@property (readonly) NSString * tag_encode;
@property (readonly) NSUInteger tag_count;
@property (readonly) NSDate * created_time;
@property (readonly) GKCreator * creator;
@property (readonly) NSMutableArray * previews;
- (id)initWithAttributes:(NSDictionary *)attributes;

+ (void)globalAvaiableTagsWithBlock:(void (^)(NSArray * taglist, NSError * error))block;
+ (void)globalTagsDetailWithTagName:(NSString *)tag_encode
                             UserID:(NSUInteger)user_id
                               Page:(NSUInteger)page
                               Size:(NSUInteger)size
                              Block:(void (^)(NSDictionary * dict, NSError * error))block;
@end
