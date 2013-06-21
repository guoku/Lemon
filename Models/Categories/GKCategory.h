//
//  GKCategory.h
//  Grape
//
//  Created by 谢家欣 on 13-4-4.
//  Copyright (c) 2013年 guoku. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GKCategory : NSObject

@property (readonly) NSUInteger category_id;
@property (readonly) NSString * cname;
@property (readonly) NSString * ename;

- (id)initWithAttributes:(NSDictionary *)attributes;

+ (NSArray *)getCategoryList;
@end
