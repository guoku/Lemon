//
//  GKPopular.h
//  Grape
//
//  Created by 谢家欣 on 13-3-23.
//  Copyright (c) 2013年 guoku. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GKEntity.h"
@interface GKPopular : GKEntity


+ (void)globalPopularWithGroup:(NSString *)group
                         Block:(void (^)(NSArray *populars, NSError * error))block;
@end
