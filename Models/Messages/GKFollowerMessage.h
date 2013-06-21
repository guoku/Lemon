//
//  GKGKFollowerMessage.h
//  Grape
//
//  Created by 谢 家欣 on 13-4-22.
//  Copyright (c) 2013年 guoku. All rights reserved.
//

#import <Foundation/Foundation.h>

@class GKUser;

@interface GKFollowerMessage : NSObject

@property (readonly) GKUser * user;
- (id)initWithAttributes:(NSDictionary *)attributes;
@end
