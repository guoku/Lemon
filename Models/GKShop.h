//
//  GKShop.h
//  MMM
//
//  Created by huiter on 13-7-5.
//  Copyright (c) 2013年 guoku. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GKShop : NSObject

@property (readonly) NSString * title;
@property (readonly) float price;
@property (readonly) NSString * url;
@property (readonly) float item_score;
@property (readonly) float delivery_score;
@property (readonly) float service_score;
@property (readonly) NSUInteger volume;

- (id)initWithAttributes:(NSDictionary *)attributes;
@end
