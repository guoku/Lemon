//
//  MMMTML.h
//  MMM
//
//  Created by huiter on 13-6-18.
//  Copyright (c) 2013年 guoku. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TMLCate.h"
#import "TMLKeyWord.h"
#import "GKEntity.h"
@interface MMMTML : NSObject
@property (readonly) NSString *type;
@property (readonly) id object;
- (id)initWithAttributes:(NSDictionary *)attributes;
+ (void)globalTMLWithBlock:(void (^)(NSDictionary * dictionary,NSArray * array, NSError * error))block;
+ (void)globalTMLEntityWithBlock:(void (^)(NSArray * array, NSError * error))block;
@end
