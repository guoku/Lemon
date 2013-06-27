//
//  TMLKeyWord.h
//  MMM
//
//  Created by huiter on 13-6-18.
//  Copyright (c) 2013年 guoku. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TMLKeyWord : NSObject
@property (readonly) NSString *name;
@property (readonly) NSUInteger kid;
@property (assign) BOOL necessary;
@property (assign) NSInteger count;
- (id)initWithAttributes:(NSDictionary *)attributes;
@end
