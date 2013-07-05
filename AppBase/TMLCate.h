//
//  TMLCate.h
//  MMM
//
//  Created by huiter on 13-6-18.
//  Copyright (c) 2013年 guoku. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TMLCate : NSObject
@property (readwrite) NSString *name;
@property (readwrite) NSUInteger cid;
- (id)initWithAttributes:(NSDictionary *)attributes;
@end
