//
//  GKVersion.h
//  Grape
//
//  Created by 谢家欣 on 13-5-4.
//  Copyright (c) 2013年 guoku. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GKVersion : NSObject

@property (readonly) NSString * device;
@property (readonly) NSString * version;
@property (readonly) NSString * message;
@property (readonly) NSDate * pub_time;

- (id)initWithAttributes:(NSDictionary *)attributes;
+ (void)getAppVersionWithBlock:(void (^)(NSDictionary * dict, NSError * error))block;
@end
