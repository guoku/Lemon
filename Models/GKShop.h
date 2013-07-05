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

- (id)initWithAttributes:(NSDictionary *)attributes;
@end
