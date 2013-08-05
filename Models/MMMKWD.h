//
//  MMMKWD.h
//  MMM
//
//  Created by huiter on 13-7-8.
//  Copyright (c) 2013年 guoku. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MMMKWD : NSObject
+ (void)globalKWDWithGroup:(NSString *)group Pid:(NSUInteger)pid Cid:(NSUInteger)cid Page:(NSUInteger)page
                         Block:(void (^)(NSArray *array, NSError * error))block;
+ (void)globalNewKWDWithGroup:(NSString *)group Pid:(NSUInteger)pid Gid:(NSUInteger)gid Cid:(NSUInteger)cid Page:(NSUInteger)page
                        Block:(void (^)(NSArray *array, NSError * error))block;
@end
