//
//  GKEntityBase.h
//  MMM
//
//  Created by huiter on 13-7-17.
//  Copyright (c) 2013年 guoku. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GKEntityBase : NSObject

@property (readonly) NSUInteger entity_id;
@property (unsafe_unretained, readonly) NSURL * imageURL;
@property (readonly) NSString * title;
@property (readonly) NSString * brand;
@property (readonly) float avg_score;
@property (readwrite) NSUInteger my_score;

- (id)initWithAttributes:(NSDictionary *)attributes;
@end
